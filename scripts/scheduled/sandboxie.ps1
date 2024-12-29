
function Check-Sandboxie() {
    $uri = 'https://www.sandboxie.com/DownloadSandboxie';
    $known = '5.33.1';

    $response = Invoke-WebRequest -Uri $uri -Method Get ;
    $html = $response.Content;

    $pos1 = $html.IndexOf('<em>') + '<em>'.Length;
    $pos2 = $html.IndexOf('</em>', $pos1);
    $latest = $html.Substring($pos1, $pos2 - $pos1);
    if ($latest -ne $known) {
        echo "Upgradable: Sandboxie ${latest}"
    }
}

Check-Sandboxie
