function Set-PasswordGUI
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Param1
    )
    
    write-warning "This function is depricated in favor of the ADTools module version."

    function GetSetPasswordCommand ($UserID, $Password, $Server)
    {
        if ([string]::IsNullOrEmpty($Password))
        {
            $Password = "<Password>"
        }
        
        if ([string]::IsNullOrEmpty($UserID))
        {
            $UserID = "<UserID>"
        }
        else
        {
            $UserID = "'$UserID'"
        }

        if ([string]::IsNullOrEmpty($Server))
        {
            $Server = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
        }

        if ([string]::IsNullOrEmpty($UserID) -or[string]::IsNullOrEmpty($Password) )
        {
            $tbx_PowerShellcommand.Background = "Red"
        }
        else
        {
            $tbx_PowerShellcommand.Background = "white"
        }

        "Set-ADAccountPassword -Identity $UserID -Reset -NewPassword `$`(ConvertTo-SecureString -AsPlainText '$Password' -Force`) -Server $Server"
    }

    [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml] $XAMLform = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Password Reset" Height="450" Width="538">
    <Grid Margin="0,0,0,22.8">
        <Label x:Name="lbl_SpecialCharacters" Content="# of special Characters:" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top"/>
        <Button x:Name="btn_Generate" Content="Generate" HorizontalAlignment="Left" Margin="216,13,0,0" VerticalAlignment="Top" Width="75"/>
        <TextBox x:Name="tbx_Password" HorizontalAlignment="Left" Height="25" Margin="145,41,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="230"/>
        <Label x:Name="lbl_Password" Content="Password:" HorizontalAlignment="Left" Margin="10,41,0,0" VerticalAlignment="Top" Width="130"/>
        <Label x:Name="lbl_Username" Content="UserName:" HorizontalAlignment="Left" Margin="10,98,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="tbx_Username" HorizontalAlignment="Left" Height="23" Margin="145,98,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="230"/>
        <Button x:Name="btn_Search" Content="Search" HorizontalAlignment="Left" Margin="409,101,0,0" VerticalAlignment="Top" Width="75"/>
        <ListBox x:Name="tbx_SearchResults" HorizontalAlignment="Left" Height="73" Margin="145,136,0,0" VerticalAlignment="Top" Width="363"/>

        <TextBox x:Name="tbx_PowerShellcommand" HorizontalAlignment="Left" Height="100" Margin="145,234,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="363" IsReadOnly="True"/>

        <Label x:Name="lbl_PowerShell" Content="PowerShell:" HorizontalAlignment="Left" Margin="10,234,0,0" VerticalAlignment="Top" Width="122"/>
        <Button x:Name="btn_SetPassword" Content="Set Password" HorizontalAlignment="Left" Margin="350,350,0,0" VerticalAlignment="Top" Width="75"/>
        <TextBox x:Name="tbx_SpecialCharacters" HorizontalAlignment="Left" Height="23" Margin="146,10,0,0" TextWrapping="Wrap" Text="2" VerticalAlignment="Top" Width="53" TextAlignment="Right"/>
        <Button x:Name="btn_Cancel" Content="Cancel" HorizontalAlignment="Left" Margin="430,350,0,0" VerticalAlignment="Top" Width="75"/>
        <Label x:Name="lbl_Version" Content="v0.1" HorizontalAlignment="Left" Margin="490,0,0,0" VerticalAlignment="Top"/>

    </Grid>
</Window>
'@

        #<Label x:Name="lbl_PowerShellcommand" Content="Set-ADPassword" HorizontalAlignment="Left" Margin="145,234,0,0" VerticalAlignment="Top" Width="363"/>
        #<ListBox x:Name="tbx_PowerShellcommand" HorizontalAlignment="Left" Height="73" Margin="145,136,0,0" VerticalAlignment="Top" Width="363"/>


    $reader=(New-Object System.Xml.XmlNodeReader $XAMLform)
    $Form=[Windows.Markup.XamlReader]::Load( $reader )


    # tbx_Password
    $tbx_Password = $Form.findName("tbx_Password")

    # tbx_Username
    $tbx_Username = $Form.findName("tbx_Username")

    # tbx_SearchResults
    $tbx_SearchResults = $Form.findName("tbx_SearchResults")

    # tbx_SpecialCharacters
    $tbx_SpecialCharacters = $Form.findName("tbx_SpecialCharacters")

    # btn_Search
    $btn_Search = $Form.findName("btn_Search")

    # btn_Generate
    $btn_Generate = $Form.findName("btn_Generate")

    # btn_SetPassword
    $btn_SetPassword = $Form.findName("btn_SetPassword")

    # btn_Cancel
    $btn_Cancel = $Form.findName("btn_Cancel")

    # tbx_PowerShellcommand
    $tbx_PowerShellcommand = $Form.findName("tbx_PowerShellcommand")

    # Cancel button
    $btn_Cancel.Add_Click({
        $Form.Close()
    })

    # Generate button
    $btn_Generate.Add_Click({
        #$tbx_Password | gm |ft * -auto -force | out-string -stream | % {write-host -fore yellow "$_"}
        #$tbx_SearchResults | gm |ft * -auto -force | out-string -stream | % {write-host -fore yellow "$_"}
        [string] $PasswordString = "$(Get-SimplePassword -SymbolCount $($tbx_SpecialCharacters.text))"
        $PasswordString = $PasswordString.remove($PasswordString.IndexOf([char]13),1)
        $tbx_Password.Text = $PasswordString 
        write-host -fore yellow "Password generated: $PasswordString"
        $tbx_PowerShellcommand.Text = GetSetPasswordCommand -UserID $($tbx_SearchResults.SelectedItem) -Password $PasswordString
    })

    # Find User
    $btn_Search.Add_Click({
        $SearchText = $tbx_Username.Text
        if ([string]::IsNullOrEmpty($SearchText))
        {
            $tbx_Username.Text = "Username"
            return
        }
        else
        {
            $found = Get-ADObject -LDAPFilter "(|(anr=$SearchText))" -server ([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name)
        }
        
        #$tbx_SearchResults.BeginUpdate()
        $tbx_SearchResults.Items.Clear()
        foreach ($entry in $Found)
        {
            $tbx_SearchResults.Items.Add($($entry.distinguishedName))
        }
        # $tbx_SearchResults.Items[0] | gm |ft * -auto -force | out-string -stream | % {write-host -fore yellow "$_"}


    })

    $tbx_SearchResults.Add_SelectionChanged({
        $tbx_PowerShellcommand.Text = GetSetPasswordCommand -UserID $($tbx_SearchResults.SelectedItem) -Password $($tbx_Password.Text)
    })


    $result = $Form.ShowDialog()
}

