# Start with default theme:
#oh-my-posh init pwsh | Invoke-Expression
# Start with jandedobbeleer theme:
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
# Better icons
Import-Module Terminal-Icons
# Code completion
Import-Module PSReadLine
ReadLineOption -PredictionViewStyle ListView