---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Set-MKPowerShellSetting.md
schema: 2.0.0
---

# Set-MKPowerShellSetting

## SYNOPSIS
Sets value to JSON data in `MK.PowerShell-config.json`.

## SYNTAX

```
Set-MKPowerShellSetting [-Value] <Object> [[-ConfigFilePath] <String>] [-PassThru] [[-Name] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ConfigFilePath
{{Fill ConfigFilePath Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: TurnOnAvailableUpdates, TurnOnQuickRestart, TurnOnRememberLastLocation, TurnOnBackup, TurnOnBetterFormats, NuGetApiKey, TurnOnHistoryRecording, BackupPolicy, LastLocation, Backups, HistoryLocation

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
{{Fill PassThru Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
{{Fill Value Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[`Get-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Get-MKPowerShellSetting.md)