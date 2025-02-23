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
	SEE_NEXT_SWARM_UPGRADE,
	SPREAD,
	AUTOCLICK_COORDINATION,
	NO_LAG,
	AUTOCLICK_DOUBLE,
	DATA_TO_INTEL
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

var eraserbotsUpgrades = [true, true, true, true, true, true]

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
	if totalDataErased >= 2048 and eraserbotsUpgrades[0]:
		add_child(createUpgrade("Eraserbot", "Autoclick on random data blocks", upgradeId.AUTO_CLICK))
		eraserbotsUpgrades[0] = false
	if totalDataErased >= 4096 and eraserbotsUpgrades[1]:
		add_child(createUpgrade("Eraserbot", "Autoclick on random data blocks", upgradeId.AUTO_CLICK))
		eraserbotsUpgrades[1] = false
	if totalDataErased >= 16384 and eraserbotsUpgrades[2]:
		add_child(createUpgrade("Eraserbot", "Autoclick on random data blocks", upgradeId.AUTO_CLICK))
		eraserbotsUpgrades[2] = false
	if totalDataErased >= 65536 and eraserbotsUpgrades[3]:
		add_child(createUpgrade("Eraserbot", "Autoclick on random data blocks", upgradeId.AUTO_CLICK))
		eraserbotsUpgrades[3] = false
	if totalDataErased >= 262144 and eraserbotsUpgrades[4]:
		add_child(createUpgrade("Eraserbot", "Autoclick on random data blocks", upgradeId.AUTO_CLICK))
		eraserbotsUpgrades[4] = false
	if totalDataErased >= 1048576 and eraserbotsUpgrades[5]:
		add_child(createUpgrade("Eraserbot", "Autoclick on random data blocks", upgradeId.AUTO_CLICK))
		eraserbotsUpgrades[5] = false

func _on_upgrade_purchased(upgradeIdentifier, intelCost) -> void:
	get_parent().changeIntel(-intelCost)
	if upgradeIdentifier == upgradeId.GRID_SIZE:
		get_parent().increaseGridSize(gridSizeArray.pop_front())
	if upgradeIdentifier == upgradeId.FETCH_FASTER:
		get_parent().speedUpFetching(false)
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
	if upgradeIdentifier == upgradeId.SPREAD:
		get_parent().increaseSpred()
	if upgradeIdentifier == upgradeId.AUTOCLICK_COORDINATION:
		get_parent().coordinateEraserbots()
	if upgradeIdentifier == upgradeId.NO_LAG:
		get_parent().speedUpFetching(true)
	if upgradeIdentifier == upgradeId.AUTOCLICK_DOUBLE:
		get_parent().doulbeEraserbotsPower()
	if upgradeIdentifier == upgradeId.DATA_TO_INTEL:
		get_parent().turnOnDatafuel()

var intelUpgradeFlags = [true, true, true, true, true, true, true, true]

func onIntelChange(totalIntel) -> void:
	if totalIntel >= 10 and intelUpgradeFlags[0]:
		add_child(createUpgrade("Anti-lag", "Fetch data blocks slightly faster", upgradeId.FETCH_FASTER, 20))
		add_child(createUpgrade("Grid size", "Fetch more data blocks at once", upgradeId.GRID_SIZE, 20))
		add_child(createUpgrade("Swarm vision", "Predict when the next swarm upgrade will occur", upgradeId.SEE_NEXT_SWARM_UPGRADE, 20))
		intelUpgradeFlags[0] = false
	if totalIntel >= 50 and intelUpgradeFlags[1]:
		add_child(createUpgrade("Bandwidth", "More data per block", upgradeId.BANDWIDTH, 60))
		add_child(createUpgrade("Digital contagion", "Replicate faster", upgradeId.SPREAD, 60))
		intelUpgradeFlags[1] = false
	if totalIntel >= 100 and intelUpgradeFlags[2]:
		add_child(createUpgrade("Anti-lag", "Fetch data blocks slightly faster", upgradeId.FETCH_FASTER, 100))
		add_child(createUpgrade("Grid size", "Fetch more data blocks at once", upgradeId.GRID_SIZE, 100))
		add_child(createUpgrade("Bot efficienty", "Eraserbots delete more blocks", upgradeId.AUTOCLICK_DOUBLE, 100))
		intelUpgradeFlags[2] = false
	if totalIntel >= 200 and intelUpgradeFlags[3]:
		add_child(createUpgrade("Anti-lag", "Fetch data blocks slightly faster", upgradeId.FETCH_FASTER, 200))
		add_child(createUpgrade("Grid size", "Fetch more data blocks at once", upgradeId.GRID_SIZE, 200))
		add_child(createUpgrade("Bandwidth", "More data per block", upgradeId.BANDWIDTH, 200))
		add_child(createUpgrade("Bot coordination", "Eraserbots now target the first available block", upgradeId.AUTOCLICK_COORDINATION, 250))
		intelUpgradeFlags[3] = false
	if totalIntel >= 500 and intelUpgradeFlags[4]:
		add_child(createUpgrade("No-lag", "Fetch data instantanly", upgradeId.NO_LAG, 600))
		add_child(createUpgrade("Bot efficienty", "Eraserbots delete more blocks", upgradeId.AUTOCLICK_DOUBLE, 200))
		add_child(createUpgrade("Bandwidth", "More data per block", upgradeId.BANDWIDTH, 500))
		add_child(createUpgrade("Digital contagion", "Replicate faster", upgradeId.SPREAD, 100))
		intelUpgradeFlags[4] = false
	if totalIntel >= 1000 and intelUpgradeFlags[5]:
		add_child(createUpgrade("No-lag", "Fetch data instantanly", upgradeId.NO_LAG, 600))
		add_child(createUpgrade("Bot efficienty", "Eraserbots delete more blocks", upgradeId.AUTOCLICK_DOUBLE, 400))
		add_child(createUpgrade("Bandwidth", "More data per block", upgradeId.BANDWIDTH, 500))
		add_child(createUpgrade("Digital contagion", "Replicate faster", upgradeId.SPREAD, 200))
		intelUpgradeFlags[5] = false
	if totalIntel >= 2000 and intelUpgradeFlags[6]:
		add_child(createUpgrade("Datafuel", "Erasing data increases INTEL", upgradeId.DATA_TO_INTEL, 800))
		add_child(createUpgrade("Digital contagion", "Replicate faster", upgradeId.SPREAD, 400))
		intelUpgradeFlags[6] = false
	if totalIntel >= 3000 and intelUpgradeFlags[7]:
		add_child(createUpgrade("Digital contagion", "Replicate faster", upgradeId.SPREAD, 800))
	for c in get_children():
		if "checkButtonEnabling" in c:
			c.checkButtonEnabling(totalIntel)
