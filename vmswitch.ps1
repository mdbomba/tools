#Requires -RunAsAdministrator
##########################################################
# PowerShell script to create a new NAT Switch for Hyper-V
##########################################################
#
# CHANGE BELOW TO THE NAME AND IP CONFIGURATION YOU WANT TO USE FOR YOUR NEW HYPER-V NAT SWITCH
$Switch = "NATSwitch"
$IPAddress = "10.0.0.1"
$IPRange = "10.0.0.0"
$IPPrefix = "24"
#
# TEST TO SEE IF SWITCH ALREADY EXISTS
$test = ''
$test = Get-NetAdapter -Name "vEthernet ($Switch)" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
if ( "$test" -ne '' ) {echo "Switch named $Switch already exists. Exiting script"; exit}
#
# CREATE THE NAT SWITCH
New-VMSwitch -SwitchName "$Switch" -SwitchType Internal
#
# COLLECT INTERFACE INDEX NUMBER FROM INTERFACE CREATED WHEN NEW SWITCH WAS CREATED
$Index = (Get-NetAdapter -Name "vEthernet ($Switch)").ifindex
#
# ADD IP ADDRESS TO INTERFACE CREATED WHEN NEW SWITCH WAS CREATED
New-NetIPAddress -InterfaceIndex "$Index" -IPAddress "$IPAddress" -PrefixLength "$IPPrefix"
#
# CREATE A NET NetNAT FOR THE NEW NAT SWITCH INTERFACE
New-NetNat -Name "$Switch Outside" -InternalIPInterfaceAddressPrefix "$IPRange/$IPPrefix"
#
# RELAX WINDOWS DEFENDER FIREWALL SETTINGS FOR PRIVATE NETWORK
Set-NetFirewallProfile -Profile Private -Enabled False
Set-NetConnectionProfile -InterfaceIndex "$Index" -NetworkCategory Private
#
# DISPLAY RESULTING WINDOWS DEFENDER FIREWALL SETTINGS
#
Get-NetFirewallProfile | Format-Table Name, Enabled
#
###############
# END OF SCRIPT
###############