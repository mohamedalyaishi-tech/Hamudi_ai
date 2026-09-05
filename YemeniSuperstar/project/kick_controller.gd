extends RigidBody3D

# متغيرات التحكم
var is_dragging = false
var start_pos = Vector2()
var current_pos = Vector2()
var drag_force_multiplier = 15.0 # قوة الركلة

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            # بداية السحب
            start_pos = event.position
            is_dragging = true
        else:
            # نهاية السحب (إطلاق الكرة)
            if is_dragging:
                _kick_ball()
                is_dragging = false
    
    elif event is InputEventScreenDrag and is_dragging:
        current_pos = event.position

func _kick_ball():
    # حساب اتجاه وقوة الركلة
    var drag_vector = start_pos - current_pos
    var force = drag_vector.normalized() * drag_vector.length() * drag_force_multiplier
    
    # تطبيق القوة على الكرة (باتجاه الكاميرا)
    apply_impulse(force, Vector3.ZERO)
    
    print("⚽ تم الركل! القوة:", force.length())

func _ready():
    # تجميد الكرة في البداية عشان ما تتدحرج لحالها
    freeze = true
    await get_tree().create_timer(1.0).timeout
    freeze = false
    print("🎮 Yemeni Superstar جاهزة للعب!")
