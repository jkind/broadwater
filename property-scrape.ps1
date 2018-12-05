param(
    [Parameter(Mandatory=$True)]
    [string]$address
)

$baseUrl = "http://www.pcpao.org/"
$searchUrl = $baseUrl + "query_address.php"
$dataExtractUrl = $baseUrl + "data_extract/data_extract.php"
$querystring = "?nR=25&Addr2=" + [uri]::EscapeDataString($address)
$uri = $url + $querystring
$linkKey = "general.php"

$searchTime = try{ 
    $searchRequest = $null 
    ## Request the URI, and measure how long the response took. 
    $result1 = Measure-Command {$searchRequest = Invoke-WebRequest -Uri $uri }
    $result1.TotalMilliseconds 
}
catch { 
    <# If the request generated an exception (i.e.: 500 server 
    error or 404 not found), we can pull the status code from the 
    Exception.Response property #> 
    $searchRequest = $_.Exception.Response 
    $searchTime = -1
}

$detailTime = try{ 
    $detailLink= $searchRequest.Links | Where-Object { $_.href.StartsWith($linkKey)}
    $detailUri = $baseUrl + $detailLink.href
    $detailRequest = $null
    ## Request the URI, and measure how long the response took. 
    $result1 = Measure-Command {$detailRequest = Invoke-WebRequest -Uri $detailUri }
    $result1.TotalMilliseconds 
}
catch { 
    <# If the request generated an exception (i.e.: 500 server 
    error or 404 not found), we can pull the status code from the 
    Exception.Response property #> 
    $detailRequest = $_.Exception.Response 
    $detailTime = -1
}

Write-Output $detailRequest