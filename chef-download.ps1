
clear

# Enter a vald license id for downloads
$license="free-5e1b4b36-424c-4110-8b0c-60cad1581b38-7632"

# DECLARE FUNCTION
function SelectFrom-List {
    param (
        [Parameter(Mandatory)]
        [string]$Label,

        [Parameter(Mandatory)]
        [object[]]$Values
    )

    if (-not $Values -or $Values.Count -eq 0) {
        throw "Values list for '$Label' is empty or null."
    }

    do {
        Write-Host ""
        Write-Host "##################"
        Write-Host "Available $Label"
        Write-Host "##################"
        Write-Host ""

        $Values | ForEach-Object { Write-Host $_ }

        $r = Read-Host -Prompt "Enter a $Label value from above"
    }
    while ($Values -notcontains $r)

    return $r
}

# Sets a short variable for license ID
$l = $license

# Available channels
$channels=@('stable','latest')
# Select a Channel from the list above`
$c = SelectFrom-List -Label "Channel" -Values $channels

# Collects a list of products
$products=(iwr https://chefdownload-commercial.chef.io/products).Content | convertfrom-json
# Select a product from the list of products`
$p = SelectFrom-List -Label "Products" -Values $products

# Collects a list of platforms
$platforms=(iwr https://chefdownload-commercial.chef.io/platforms).Content | convertfrom-json
$platforms = $platforms.PSObject.Properties.Name
# Select a Platform from the list of platforms`
$os = SelectFrom-List -Label "Operating System" -Values $platforms

# Collects a list of OS Versions for a given product and OS
$distros = (((iwr https://chefdownload-commercial.chef.io/$c/$p/packages?license_id=$l).content) | ConvertFrom-JSON).$os
$versions = $distros.PSObject.Properties.Name
# Selects a specific OS Version
$v = SelectFrom-List -Label "OS Version" -Values $versions

# Create list of Architectures for a specific OS and OS Version
$archlist = $distros.$v.PSObject.Properties.Name
# Selects a specific Architecture for a specific OS and OS Version
$a = SelectFrom-List -Label "Architecture for $os.$v" -Values $archlist

# Calculate download URL and OutFile Name and Extension
$uri = ""
$OutFile = ""
#
if ( ("automate","chef-360") -notcontains "$p" ) { 
  if ( ("linux","linux-kernel2","debian","ubuntu") -contains $os ) { $OutFile="${p}${v}${a}.deb" }
  if ( ("el","amazon","rocky","sles","suse","aix" ) -contains $os ) { $OutFile="${p}${v}${a}.rpm" }
  if ( ("windows" ) -contains $os ) { $OutFile="${p}${v}${a}.msi" }
  if ( ("solaris2", "darwin", "mac_os_x", "freebsd" ) -contains $os ) { $OutFile="${p}${v}${a}.pkg" }
  $uri=((iwr "https://chefdownload-commercial.chef.io/$c/$p/packages?license_id=$l").content | ConvertFrom-Json ).$os.$v.$a.url
}
#
if ( "$p" -eq "automate" ) {
  $OutFile = "automate.zip"
  $uri=(((iwr "https://chefdownload-commercial.chef.io/stable/automate/packages?license_id=$l").content | ConvertFrom-Json ).linux.pv.amd64.url)
}
#
if ( "$p" -eq "chef-360" ) {
  write-host "Download URI and Access Token WILL BE PROVIDED BY CHEF SUPPORT"
}

# EXIT IF URL COULD NOT BE CALCULATED
if ( $uri -eq "" ) { Write-Host "Could not calculate download URL. Exiting Script."; exit }

# DISPLAY SELECTION AND ASK TO CONTINUE
Write-Host ""
Write-Host "Distro            = $c"
Write-Host "Product           = $p"
Write-Host "Operating System  = $os $v $a"
Write-Host "OutFile           = $OutFile"
Write-Host "Download URL      = $uri"
write-host ""
read-host "Press Enter to continue to download section, or CTRL-C to abort "

# Download Chef Install File
iwr -uri "$uri" -OutFile "$OutFile" 
