$modelname	"props\acceleration\sign.mdl"
$scale 15
$body mybody	"Sign.smd"

$staticprop
$surfaceprop	combine_metal

$scale 15
$cdmaterials	"models\props\acceleration\sign"

$sequence idle	"Sign.smd"

$collisionmodel	"Sign_phys.smd" { $concave }