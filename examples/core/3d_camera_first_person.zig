// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const MAX_COLUMNS = 20;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - 3d camera first person");

    var camera = rl.Camera3D{
        .position = rl.Vector3.init(4, 2, 4),
        .target = rl.Vector3.init(0, 1.8, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 60,
        .projection = rl.CameraProjection.camera_perspective,
    };

    var heights: [MAX_COLUMNS]f32 = undefined;
    var positions: [MAX_COLUMNS]rl.Vector3 = undefined;
    var colors: [MAX_COLUMNS]rl.Color = undefined;

    for (heights) |_, i| {
        heights[i] = @intToFloat(f32, rl.getRandomValue(1, 12));
        positions[i] = rl.Vector3.init(@intToFloat(f32, rl.getRandomValue(-15, 15)), heights[i] / 2.0, @intToFloat(f32, rl.getRandomValue(-15, 15)));
        colors[i] = rl.Color.init(@intCast(u8, rl.getRandomValue(20, 255)), @intCast(u8, rl.getRandomValue(10, 55)), 30, 255);
    }

    camera.setMode(rl.CameraMode.camera_first_person);

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        camera.update();
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(rl.Color.ray_white);

        camera.begin();

        // Draw ground
        rl.drawPlane(rl.Vector3.init(0, 0, 0), rl.Vector2.init(32, 32), rl.Color.light_gray);
        rl.drawCube(rl.Vector3.init(-16.0, 2.5, 0.0), 1.0, 5.0, 32.0, rl.Color.blue); // Draw a blue wall
        rl.drawCube(rl.Vector3.init(16.0, 2.5, 0.0), 1.0, 5.0, 32.0, rl.Color.lime); // Draw a green wall
        rl.drawCube(rl.Vector3.init(0.0, 2.5, 16.0), 32.0, 5.0, 1.0, rl.Color.gold); // Draw a yellow wall

        // Draw some cubes around
        for (heights) |height, i| {
            rl.drawCube(positions[i], 2.0, height, 2.0, colors[i]);
            rl.drawCubeWires(positions[i], 2.0, height, 2.0, rl.Color.maroon);
        }

        camera.end();

        rl.drawRectangle(10, 10, 220, 70, rl.Color.sky_blue.fade(0.5));
        rl.drawRectangleLines(10, 10, 220, 70, rl.Color.blue);

        rl.drawText("First person camera default controls:", 20, 20, 10, rl.Color.black);
        rl.drawText("- Move with keys: W, A, S, D", 40, 40, 10, rl.Color.dark_gray);
        rl.drawText("- Mouse move to look around", 40, 60, 10, rl.Color.dark_gray);

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    rl.closeWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}