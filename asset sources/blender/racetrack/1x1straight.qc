$modelname	"props\acceleration\racetrack1x1straight.mdl"
$body mybody	"1x1straight.smd"
$staticprop
$surfaceprop	combine_metal
$scale 10
$cdmaterials	"models\props\acceleration"

$sequence idle	"1x1straight.smd"

$collisionmodel	"1x1straight_phys.smd" { $concave }