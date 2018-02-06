param(
    [string]$plan = "High performance",
    [switch]$test
)

function Done($code, $changed, $comment) {
    @{changed=$changed;comment=$comment} | ConvertTo-Json -Compress
    exit $code
}

$newPlan = powercfg -l | %{if($_.contains("($plan)")) {$_.split()[3]}}
$currentPlan = $(powercfg -getactivescheme).split()[3]

if ($currentPlan -eq $newPlan) {
    Done 0 'no' "Power plan is already set to $plan"
}

if ($test) {
    Done 0 'yes' "Power plan would change to $plan"
}

powercfg -setactive $newPlan
if ($LASTEXITCODE) {
    Done 1 'no' "Failed setting power plan to $plan"
}

Done 0 'yes' "Power plan is now set to $plan"
