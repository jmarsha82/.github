param(
    [Parameter(Mandatory = $false)]
    [string] $Owner = "jmarsha82",

    [Parameter(Mandatory = $false)]
    [string[]] $Repositories = @(),

    [Parameter(Mandatory = $false)]
    [string] $Token = $env:GITHUB_TOKEN,

    [Parameter(Mandatory = $false)]
    [string] $RulesetPath = "$PSScriptRoot\..\rulesets\require-pr-review.json"
)

$ErrorActionPreference = "Stop"

if (-not $Token) {
    throw "Pass -Token or set GITHUB_TOKEN to a token with repository Administration: write permission."
}

$headers = @{
    Accept = "application/vnd.github+json"
    Authorization = "Bearer $Token"
    "X-GitHub-Api-Version" = "2022-11-28"
}

$ruleset = Get-Content -LiteralPath $RulesetPath -Raw | ConvertFrom-Json
$rulesetBody = $ruleset | ConvertTo-Json -Depth 20

function Invoke-GitHubApi {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Method,

        [Parameter(Mandatory = $true)]
        [string] $Uri,

        [Parameter(Mandatory = $false)]
        [string] $Body
    )

    $params = @{
        Method = $Method
        Uri = $Uri
        Headers = $headers
    }

    if ($Body) {
        $params.ContentType = "application/json"
        $params.Body = $Body
    }

    Invoke-RestMethod @params
}

if ($Repositories.Count -eq 0) {
    $Repositories = @()
    $page = 1

    do {
        $uri = "https://api.github.com/user/repos?affiliation=owner&per_page=100&page=$page"
        $pageRepos = Invoke-GitHubApi -Method "GET" -Uri $uri
        $Repositories += $pageRepos |
            Where-Object { $_.owner.login -eq $Owner -and -not $_.archived } |
            ForEach-Object { $_.name }
        $page++
    } while ($pageRepos.Count -eq 100)
}

foreach ($repo in $Repositories) {
    $rulesetsUri = "https://api.github.com/repos/$Owner/$repo/rulesets"
    $existing = Invoke-GitHubApi -Method "GET" -Uri $rulesetsUri
    $match = $existing | Where-Object { $_.name -eq $ruleset.name } | Select-Object -First 1

    if ($match) {
        $updateUri = "$rulesetsUri/$($match.id)"
        Invoke-GitHubApi -Method "PUT" -Uri $updateUri -Body $rulesetBody | Out-Null
        Write-Output "Updated ruleset for $Owner/$repo"
    }
    else {
        Invoke-GitHubApi -Method "POST" -Uri $rulesetsUri -Body $rulesetBody | Out-Null
        Write-Output "Created ruleset for $Owner/$repo"
    }
}
