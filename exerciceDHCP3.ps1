#=============================================================================
#exerciceDHCP3.ps1
#Daroussi Aksam
#27/03/2024

#Version 3
  
#Exercice 3

#Demander à l'utilisateur le nom de l'étendue DHCP, l'adresse réseau de l'étendue, le masque sous-réseau, la 1ère adresse, la dernière adresse, la passerelle, le nom  du domaine et l'adresse IP du serveur de domaine grâce à l'utilisation de boites de dialogue

#=============================================================================




# Demander à l'utilisateur les informations nécessaires pour créer l'étendue DHCP

[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$nomEtendue = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez le nom de l'étendue")
$adresseReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez l'adresse réseau de l'étendue DHCP")
$masqueSousReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez le masque sous-réseau")
$premiereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez la première adresse de l'étendue DHCP")
$derniereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez la dernière adresse de l'étendue DHCP")
$passerelle = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez l'adresse de la passerelle par défaut de l'étendue DHCP")
$nomDomaine = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez le nom du domaine")
$adresseIPDomaine = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez l'adresse IP du serveur de domaine")


# Afficher les informations saisies par l'utilisateur
Write-Host "Nom de l'étendue DHCP : $nomEtendue"
Write-Host "Adresse réseau de l'étendue : $adresseReseau"
Write-Host "Masque sous-réseau : $masqueSousReseau"
Write-Host "Première adresse de l'étendue : $premiereAdresse"
Write-Host "Dernière adresse de l'étendue : $derniereAdresse"
Write-Host "Passerelle par défaut : $passerelle"
Write-Host "Nom de domaine : $nomDomaine"
Write-Host "Adresse IP du serveur de domaine : $adresseIPDomaine"

# Demander confirmation à l'utilisateur
$confirmation = Read-Host "Confirmez-vous la création de cette étendue DHCP ? (O/N)"

# Vérifier la réponse de l'utilisateur
if ($confirmation -eq "O" -or $confirmation -eq "o") {
    # Créer l'étendue DHCP en utilisant les informations fournies par l'utilisateur
    Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau -State Active -LeaseDuration 8.00:00:00 -Description "Créée via PowerShell" -ActivatePolicies $true

    # Ajouter l'option de la passerelle par défaut à l'étendue DHCP
    Add-DhcpServerv4OptionDefinition -Name 'Router' -Description 'Default Gateway' -Type IPADDRESS -OptionID 3
    Set-DhcpServerv4OptionValue -Router $passerelle -ScopeID ((Get-DhcpServerv4Scope -Name $nomEtendue).ScopeID)

    # Ajouter l'option du serveur de domaine à l'étendue DHCP
    Add-DhcpServerv4OptionDefinition -Name 'Domain Name Server' -Description 'DNS Servers' -Type IPADDRESS -OptionID 6
    Set-DhcpServerv4OptionValue -DnsServer $adresseIPDomaine -ScopeID ((Get-DhcpServerv4Scope -Name $nomEtendue).ScopeID)


    Write-Host "L'étendue DHCP a été créée avec succès."
} else {
    Write-Host "Création de l'étendue DHCP annulée."
}

#Add-DhcpServerv4Scope -Name "VLAN 30 Visiteurs" -StartRange 192.168.5.201 -EndRange 192.168.5.205 -SubnetMask 255.255.255.248