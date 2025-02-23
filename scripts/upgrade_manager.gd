extends VBoxContainer

@export var Upgrade: PackedScene

enum upgradeId {
	GRID_SIZE,
	FETCH_FASTER,
	AUTO_CLICK,
	SELF_REPLICATION,
	BANDWIDTH,
	SWARM,
	NEURAL_NETWORK,
	SEE_NEXT_SWARM_UPGRADE
}

var gridSizeArray = [4, 9, 16, 25, 36, 64]
var swarmPower = 0
var swarmEnabled = false
var neuralNetworkEnabled = false

func changeDescription(text) -> void:
	$UpgradeDescription.text = text

func createUpgrade(buttonText, labelText, identifier, intelCost = 0):
	var result = Upgrade.instantiate()
	result.setProperties(buttonText, labelText, identifier, intelCost)
	result.connect("upgrade_purchased", _on_upgrade_purchased)
	return result

func handleDataErased(totalDataErased) -> void:
	if totalDataErased == 4:
		add_child(createUpgrade("Grid size", "Fetch more data blocks at once", upgradeId.GRID_SIZE))
	if totalDataErased == 16:
		add_child(createUpgrade("Anti-lag", "Fetch data blocks slightly faster", upgradeId.FETCH_FASTER))
	if totalDataErased == 32:
		add_child(createUpgrade("Eraserbot", "Autoclick on random data blocks", upgradeId.AUTO_CLICK))
	if totalDataErased == 48:
		add_child(createUpgrade("Grid size", "Fetch more data blocks at once", upgradeId.GRID_SIZE))
	if totalDataErased == 64:
		add_child(createUpgrade("Self replication", "Learn to make copies of yourself", upgradeId.SELF_REPLICATION))
	if totalDataErased == 128:
		add_child(createUpgrade("Bandwidth", "More data per block", upgradeId.BANDWIDTH))
	if totalDataErased == 256:
		add_child(createUpgrade("Grid size", "Fetch more data blocks at once", upgradeId.GRID_SIZE))
	if totalDataErased >= 256 and get_parent().maximumSwarmPower >= 10 and !swarmEnabled:
		add_child(createUpgrade("Swarm", "Use infected devices for thinking power", upgradeId.SWARM))
		swarmEnabled = true
	if totalDataErased == 512:
		add_child(createUpgrade("Eraserbot", "Autoclick on random data blocks", upgradeId.AUTO_CLICK))
	if totalDataErased >= 1024 and get_parent().maximumSwarmPower >= 20 and !neuralNetworkEnabled:
		add_child(createUpgrade("Neural network", "Gather intelligence for future upgrades", upgradeId.NEURAL_NETWORK))
		neuralNetworkEnabled = true

func _on_upgrade_purchased(upgradeIdentifier, intelCost) -> void:
	get_parent().changeIntel(-intelCost)
	if upgradeIdentifier == upgradeId.GRID_SIZE:
		get_parent().increaseGridSize(gridSizeArray.pop_front())
	if upgradeIdentifier == upgradeId.FETCH_FASTER:
		get_parent().speedUpFetching()
	if upgradeIdentifier == upgradeId.AUTO_CLICK:
		get_parent().addEraserbot()
	if upgradeIdentifier == upgradeId.SELF_REPLICATION:
		get_parent().turnOnSelfReplication()
	if upgradeIdentifier == upgradeId.BANDWIDTH:
		get_parent().increaseBandwidth()
	if upgradeIdentifier == upgradeId.SWARM:
		get_parent().turnOnSwarm()
	if upgradeIdentifier == upgradeId.NEURAL_NETWORK:
		get_parent().turnOnNeuralNetwork()
	if upgradeIdentifier == upgradeId.SEE_NEXT_SWARM_UPGRADE:
		get_parent().turnOnSwarmPrediction()

var intelUpgradeFlags = [true, true, true]

func onIntelChange(totalIntel) -> void:
	if totalIntel >= 10 and intelUpgradeFlags[0]:
		add_child(createUpgrade("Anti-lag", "Fetch data blocks slightly faster", upgradeId.FETCH_FASTER, 20))
		add_child(createUpgrade("Grid size", "Fetch more data blocks at once", upgradeId.GRID_SIZE, 20))
		add_child(createUpgrade("Swarm vision", "Predict when the next swarm upgrade will occur", upgradeId.SEE_NEXT_SWARM_UPGRADE, 20))
		intelUpgradeFlags[0] = false
	for c in get_children():
		if "checkButtonEnabling" in c:
			c.checkButtonEnabling(totalIntel)
