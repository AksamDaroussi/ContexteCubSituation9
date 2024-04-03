#=============================================================================
#exerciceDHCP4S.ps1
#Daroussi Aksam
#27/03/2024

#Version 4
  
#Exercice 4

#Demander à l'utilisateur le nombre d'étendues DHCP qu'il désire créer
#Pour chaque étendue :
    #Demander à l'utilisateur les informations nécessaires pour créer l'étendue DHCP

#=============================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

# Demander à l'utilisateur le nombre d'étendues DHCP qu'il désire créer
$nombreEtendues = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez le nombre d'étendues DHCP à créer")

for ($i = 1; $i -le $nombreEtendues; $i++) {
    # Demander à l'utilisateur les informations nécessaires pour créer l'étendue DHCP
    $nomEtendue = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez le nom de l'étendue #$i")
    $adresseReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez l'adresse réseau de l'étendue DHCP #$i")
    $masqueSousReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez le masque sous-réseau de l'étendue DHCP #$i")
    $premiereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez la première adresse de l'étendue DHCP #$i")
    $derniereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez la dernière adresse de l'étendue DHCP #$i")
    $passerelle = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez l'adresse de la passerelle par défaut de l'étendue DHCP #$i")
    $nomDomaine = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez le nom du domaine #$i")
    $adresseIPDomaine = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez l'adresse IP du serveur de domaine #$i")

    # Afficher les informations saisies par l'utilisateur pour chaque étendue
    Write-Host "-----------------------------------"
    Write-Host "Création de l'étendue DHCP #$i"
    Write-Host "Nom de l'étendue DHCP : $nomEtendue"
    Write-Host "Adresse réseau de l'étendue : $adresseReseau"
    Write-Host "Masque sous-réseau : $masqueSousReseau"
    Write-Host "Première adresse de l'étendue : $premiereAdresse"
    Write-Host "Dernière adresse de l'étendue : $derniereAdresse"
    Write-Host "Passerelle par défaut : $passerelle"
    Write-Host "Nom de domaine : $nomDomaine"
    Write-Host "Adresse IP du serveur de domaine : $adresseIPDomaine"
    Write-Host "-----------------------------------"

    # Demander confirmation à l'utilisateur pour chaque étendue
    $confirmation = Read-Host "Confirmez-vous la création de cette étendue DHCP ? (O/N)"

    # Vérifier la réponse de l'utilisateur pour chaque étendue
    if ($confirmation -eq "O" -or $confirmation -eq "o") {
        # Créer l'étendue DHCP en utilisant les informations fournies par l'utilisateur pour chaque étendue
        Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau -State Active -LeaseDuration 8.00:00:00 -Description "Créée via PowerShell" -ActivatePolicies $true

        # Ajouter l'option de la passerelle par défaut à l'étendue DHCP pour chaque étendue
        Add-DhcpServerv4OptionDefinition -Name 'Router' -Description 'Default Gateway' -Type IPADDRESS -OptionID 3
        Set-DhcpServerv4OptionValue -Router $passerelle -ScopeID ((Get-DhcpServerv4Scope -Name $nomEtendue).ScopeID)

        # Ajouter l'option du serveur de domaine à l'étendue DHCP pour chaque étendue
        Add-DhcpServerv4OptionDefinition -Name 'Domain Name Server' -Description 'DNS Servers' -Type IPADDRESS -OptionID 6
        Set-DhcpServerv4OptionValue -DnsServer $adresseIPDomaine -ScopeID ((Get-DhcpServerv4Scope -Name $nomEtendue).ScopeID)

        Write-Host "L'étendue DHCP #$i a été créée avec succès."
    } else {
        Write-Host "Création de l'étendue DHCP #$i annulée."
    }
}
