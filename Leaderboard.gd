extends VBoxContainer

const STATE_PATH = "user://dodge_the_creeps.state"

var data = [
    ["AlphaGo", 101],
    ["SkyrimGrandma", 84],
    ["Boomer", 46]
];
var row_views = [];

func _ready():
    var state = File.new()

    if state.file_exists(STATE_PATH):
        state.open(STATE_PATH, File.READ)
        data = parse_json(state.get_line()).leaderboard
        state.close()
    else:
        save_scores()

    init_view_nodes()
    update_view_nodes()

func init_view_nodes():
    add_child($LeaderboardRow.duplicate())
    add_child($LeaderboardRow.duplicate())

func update_view_nodes():
    for i in len(data):
        var row = data[i]
        var name = row[0]
        var score = row[1]

        var row_node = get_child(i + 1)
        row_node.get_node("Name").text = name
        row_node.get_node("Score").text = str(score)

func add_score(score):
    for i in len(data):
        var row_data = data[i]
        if score > row_data[1]:
            data.insert(i, ["You", score])
            data.pop_back()
            save_scores()
            update_view_nodes()
            break

func save_scores():
    var state = File.new()
    state.open(STATE_PATH, File.WRITE)
    state.store_line(to_json({
        "leaderboard": data
    }))
    state.close()
