function Get-ADObjectParentDN
{
    <#
        Copyright (c) 2016 The University Of Vermont
        All rights reserved.

        Redistribution and use in source and binary forms, with or without modification, are permitted provided that
        the following conditions are met:

        1. Redistributions of source code must retain the above copyright notice, this list of conditions and the
           following disclaimer.
        2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
           following disclaimer in the documentation and/or other materials provided with the distribution.
        3. Neither the name of the University nor the names of its contributors may be used to endorse or promote
           products derived from this software without specific prior written permission.

        THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
        LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
        IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
        CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
        OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
        CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
        THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

        http://www.uvm.edu/~gcd/code-license/
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory)]
        [System.String]
        $DN
    )

    # https://www.uvm.edu/~gcd/2012/07/listing-parent-of-ad-object-in-powershell/
    $distinguishedNameParts = $DN -split '(?<![\\]),';
    $distinguishedNameParts[1..$($distinguishedNameParts.Count-1)] -join ',';

} #end function GetADObjectParentDN
