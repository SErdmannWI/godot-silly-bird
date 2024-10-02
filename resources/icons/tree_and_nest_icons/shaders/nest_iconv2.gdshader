shader_type canvas_item;
render_mode blend_mix;

void vertex() {
    // Adjust these parameters to change the animation
    float speed = 3.0;      // Speed of the scaling animation
    float amplitude = 0.2;  // Maximum scale change (20% in this case)

    // Calculate the scaling factor using a sine wave oscillation
    float scale = 1.0 + sin(TIME * speed) * amplitude;

    // Apply the scaling to the vertex positions
    VERTEX *= scale;
}
