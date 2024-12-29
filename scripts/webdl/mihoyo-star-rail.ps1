[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

Add-Type -AssemblyName System.Web

$ProgressPreference = 'SilentlyContinue'

$game_path = ""

Write-Output "Attempting to locate Warp Url!"

if ($args.Length -eq 0) {
    $app_data = [Environment]::GetFolderPath('ApplicationData')
    $locallow_path = "$app_data\..\LocalLow\miHoYo\$([char]0x5d29)$([char]0x574f)$([char]0xff1a)$([char]0x661f)$([char]0x7a79)$([char]0x94c1)$([char]0x9053)\"

    $log_path = "$locallow_path\Player.log"

    if (-Not [IO.File]::Exists($log_path)) {
        Write-Output "Failed to locate log file!"
        Write-Output "Try using the Global client script?"
        return
    }

    $log_line = Get-Content $log_path -Raw

    if ([string]::IsNullOrEmpty($log_line)) {
        $log_path = "$locallow_path\Player-prev.log"

        if (-Not [IO.File]::Exists($log_path)) {
            Write-Output "Failed to locate log file!"
            Write-Output "Try using the Global client script?"
            return
        }

        $log_line = Get-Content $log_path -First 1
    }

    if ([string]::IsNullOrEmpty($log_line)) {
        Write-Output "Failed to locate game path! (1)"
        Write-Output "Please contact support at discord.gg/srs"
    }

    $game_path = $log_line.Substring($log_line.IndexOf("Loading player data from ") + 25, 300)
    $game_path = $game_path.Substring(0, $game_path.IndexOf("/Game/StarRail_Data/data.unity3d") + 32).replace("data.unity3d", "")
} else {
    $game_path = $args[0]
}

if ([string]::IsNullOrEmpty($game_path)) {
    Write-Output "Failed to locate game path! (2)"
    Write-Output "Please contact support at discord.gg/srs"
}

$copy_path = [IO.Path]::GetTempFileName()

Copy-Item -Path "$game_path/webCaches/2.24.0.0/Cache/Cache_Data/data_2" -Destination $copy_path
$cache_data = Get-Content -Encoding UTF8 -Raw $copy_path
Remove-Item -Path $copy_path

$cache_data_split = $cache_data -split '1/0/'

for ($i = $cache_data_split.Length - 1; $i -ge 0; $i--) {
    $line = $cache_data_split[$i]

    if ($line.StartsWith('http') -and $line.Contains("getGachaLog")) {
        $url = ($line -split "\0")[0]

        $res = Invoke-WebRequest -Uri $url -ContentType "application/json" -UseBasicParsing | ConvertFrom-Json

        if ($res.retcode -eq 0) {
            $uri = [Uri]$url
            $query = [Web.HttpUtility]::ParseQueryString($uri.Query)

            $keys = $query.AllKeys
            foreach ($key in $keys) {
                # Retain required params
                if ($key -eq "authkey") { continue }
                if ($key -eq "authkey_ver") { continue }
                if ($key -eq "sign_type") { continue }
                if ($key -eq "game_biz") { continue }
                if ($key -eq "lang") { continue }
                if ($key -eq "auth_appid") { continue }
                if ($key -eq "size") { continue }

                $query.Remove($key)
            }

            $latest_url = $uri.Scheme + "://" + $uri.Host + $uri.AbsolutePath + "?" + $query.ToString()

            Write-Output "Warp History Url Found!"
            Write-Output $latest_url
            Set-Clipboard -Value $latest_url
            Write-Output "Warp History Url has been saved to clipboard."
            return;
        }
    }
}

Write-Output "Could not locate Warp History Url."
Write-Output "Please make sure to open the Warp history before running the script."
