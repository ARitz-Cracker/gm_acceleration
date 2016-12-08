$modelname	"props\acceleration\checkpoint.mdl"
$scale 3
$body mybody	"checkpoint.smd"

$staticprop
$surfaceprop	combine_metal

$scale 3
$cdmaterials	"models\props\acceleration\checkpoint"

$texturegroup skinfamilies
{
	{ "CheckpointMetal"  "CheckpointLight"}
	{ "CheckpointMetal_Var2"  "CheckpointLight"}
}

$attachment "particle_attachment" "" 0 0 10.88607 absolute rigid

$attachment "barriar_attachment_top" "" 0 9.13638 12.51101 absolute rigid
$attachment "barriar_attachment_bot" "" 0 9.13638 0.319840 absolute rigid

$sequence idle	"checkpoint.smd"

$collisionmodel	"checkpoint_phys.smd" { $concave }