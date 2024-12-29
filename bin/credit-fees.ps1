<#
.PARAMETER Principal
本金
.PARAMETER Period
期数
.PARAMETER OneshotRate
一次性手续费 %
.PARAMETER MonthlyRate
分期手续费 %
.PARAMETER DiscountedRate
利息折扣率
.PARAMETER DiscountAmount
利息返现

#>
param(
    [Parameter(Mandatory)]
    [double]$Principal,

    [Parameter(Mandatory)]
    [int]$Period,

    [double]$OneshotRate100,

    [Parameter(Mandatory)]
    [double]$MonthlyRate100,

    [double]$DiscountedRate,

    [double]$DiscountAmount
)

if ($null -eq $OneshotRate100) {
    $OneshotRate100 = 0.0
}

if (($null -eq $DiscountedRate) -or ($DiscountedRate -lt 0.01)) {
    $DiscountedRate = 1.0
}

if ($null -eq $DiscountAmount) {
    $DiscountAmount = 0.0
}

# 计算公式
#

if ($OneshotRate100 -gt 0.01) {
    $OneshotRate = $OneshotRate100 / 100.0
    $OneshotFee = $Principal * $OneshotRate
    $MonthlyEffectiveOneshotRate = $OneshotRate / $Period
    $YearlyEffectiveOneshotRate = $MonthlyEffectiveOneshotRate * 12
    Write-Host "一次性手续费 $("{0:0.00}" -f $OneshotFee)"
    Write-Host "　等效月利率 $("{0:0.00000}" -f $MonthlyEffectiveOneshotRate)" -NoNewline
    Write-Host "　等效年利率 $("{0:0.00000}" -f $YearlyEffectiveOneshotRate)"
}

$MonthlyRate = $MonthlyRate100 / 100.0
$MonthlyNominalRate = $MonthlyRate * $DiscountedRate
$Interest = ($Principal * $MonthlyNominalRate * $Period) - $DiscountAmount
$PrincipalPerPeriod = $Principal / $Period
$InterestPerPeriod = $Interest / $Period
Write-Host "本金每期 $("{0:0.00}" -f $PrincipalPerPeriod)"
Write-Host "利息每期 $("{0:0.00}" -f $InterestPerPeriod) 总计 $("{0:0.00}" -f $Interest)"

$YearlyNominalRate = $MonthlyNominalRate * 12
Write-Host "　名义月利率 $("{0:0.00000}" -f $MonthlyNominalRate)" -NoNewline
Write-Host "　名义年利率 $("{0:0.00000}" -f $YearlyNominalRate)"

# 产生原因：每月还款额固定，利息按全额算，但待还本金随月递减，后期利息本应减少
$MonthlyEffectiverate = (2 * $MonthlyNominalRate * $Period / ($Period + 1))
$YearlyEffectiverate = $MonthlyEffectiverate * 12
Write-Host "　实际月利率 $("{0:0.00000}" -f $MonthlyEffectiverate)" -NoNewline
Write-Host "　实际年利率 $("{0:0.00000}" -f $YearlyEffectiverate)"
