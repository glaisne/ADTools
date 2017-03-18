function Add-GroupMembershipGUI
{
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>

    write-warning "This function is depricated in favor of the ADTools module version."

    $TrustedDomains = Get-ADTrustedDomains

    [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml] $XAMLform = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Default Groups" Height="350" Width="525">
    <Grid>
        <Label x:Name="lbl_domain" Content="Domain" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="107"/>
        <ComboBox x:Name="cbx_domain" HorizontalAlignment="Left" Margin="122,13,0,0" VerticalAlignment="Top" Width="251"/>
        <RadioButton x:Name="rbn_NewUser" Content="New User" HorizontalAlignment="Left" Margin="122,184,0,0" VerticalAlignment="Top" GroupName="DefaultGroups"/>
        <Button x:Name  ="btn_OK" Content="OK" HorizontalAlignment="Left" Margin="433,292,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name  ="btn_Cancel" Content="Cancel" HorizontalAlignment="Left" Margin="351,292,0,0" VerticalAlignment="Top" Width="75"/>
        <Label x:Name   ="lbl_PowerShellCommand" Content="Set-ADPassword" HorizontalAlignment="Left" Margin="122,253,0,0" VerticalAlignment="Top" Width="386"/>
        <Label x:Name   ="lbl_PowerShell" Content="PowerShell:" HorizontalAlignment="Left" Margin="10,253,0,0" VerticalAlignment="Top" Width="122"/>
        <Label x:Name   ="lbl_Username" Content="UserName:" HorizontalAlignment="Left" Margin="10,53,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name ="tbx_Username" HorizontalAlignment="Left" Height="23" Margin="122,53,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="251"/>
        <Button x:Name  ="btn_Search" Content="Search" HorizontalAlignment="Left" Margin="410,56,0,0" VerticalAlignment="Top" Width="75"/>
        <ListBox x:Name ="tbx_SearchResults" HorizontalAlignment="Left" Height="73" Margin="122,91,0,0" VerticalAlignment="Top" Width="363"/>

    </Grid>
</Window>
'@

    $reader=(New-Object System.Xml.XmlNodeReader $XAMLform)
    $Form=[Windows.Markup.XamlReader]::Load( $reader )

    #
    #    Domain
    #

    $cbx_domain = $Form.findName("cbx_domain")

    $cbx_domain.Items.Add([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name) | out-null
    $cbx_domain.SelectedIndex = 0

    foreach ($Trusteddomain in $TrustedDomains)
    {
        $cbx_domain.Items.Add($Trusteddomain.cn) | out-null
    }


    #
    #    User Search
    #

    # tbx_Username
    $tbx_Username = $Form.findName("tbx_Username")

    # tbx_SearchResults
    $tbx_SearchResults = $Form.findName("tbx_SearchResults")

    # btn_Search
    $btn_Search = $Form.findName("btn_Search")



    #
    #   bottom buttons
    #

    # btn_Cancel
    $btn_Cancel = $Form.findName("btn_Cancel")

    # tbx_PowerShellcommand
    $tbx_PowerShellcommand = $Form.findName("tbx_PowerShellcommand")


    # Cancel button
    $btn_Cancel.Add_Click({
        $Form.Close()
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
            $found = Get-ADObject -LDAPFilter "(|(anr=$SearchText))" -server $($cbx_domain.Items[$cbx_domain.SelectedIndex])
        }

        #$tbx_SearchResults.BeginUpdate()
        $tbx_SearchResults.Items.Clear()
        foreach ($entry in $Found)
        {
            $tbx_SearchResults.Items.Add($($entry.distinguishedName))
        }
        $tbx_SearchResults.Items[0] | gm |ft * -auto -force | out-string -stream | % {write-host -fore yellow "$_"}


    })

    $result = $Form.ShowDialog()


}

