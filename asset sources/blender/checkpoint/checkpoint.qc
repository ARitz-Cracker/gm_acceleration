$modelname	"props\acceleration\checkpoint.mdl"
$body mybody	"checkpoint.smd"
$staticprop
$surfaceprop	combine_metal
$scale 10
$cdmaterials	"models\props\acceleration"

$sequence idle	"checkpoint.smd"

$collisionmodel	"checkpoint_phys.smd" { $concave }