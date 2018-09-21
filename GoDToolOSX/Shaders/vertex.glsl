#version 330 core

uniform mat4 view;
uniform mat4 projection;

layout (location = 0) in vec3  position;
layout (location = 1) in float type;
layout (location = 2) in float index;
layout (location = 3) in vec3  normal;
layout (location = 4) in float isWarp; // 1.0 for ture, 0.0 for false

out vec3 passPosition;
out vec3 passNormal;
out vec3 passColour;
out vec3 barycentric;

out vec2 passProjection;

void main() {
	
	gl_Position = projection * view * vec4(position, 1.0);
	
	passPosition = position;
	passNormal = vec4(view * vec4(normal, 1.0)).xyz;
	passProjection = vec4(projection * view * vec4(position, 1.0)).xy;
	
	passColour = vec3(0.8,0.8,0.8);
	
	switch (int(index) % 3) {
		case 0: barycentric = vec3(1.0,0.0,0.0); break;
		case 1: barycentric = vec3(0.0,1.0,0.0); break;
		case 2: barycentric = vec3(0.0,0.0,1.0); break;
		default: break;
	}
	
	switch (int(type)) {
		case 0: passColour = vec3(0.2,0.2,0.2); break;
		case 1: passColour = vec3(0.3,0.3,0.4); break;
		case 2: passColour = vec3(0.2,0.3,0.5); break;
		case 3: passColour = vec3(0.2,0.2,0.6); break;
		case 4: passColour = vec3(0.0,0.3,0.7); break;
		case 5: passColour = vec3(0.0,0.2,0.8); break;
		case 6: passColour = vec3(0.0,0.1,0.9); break;
		case 7: passColour = vec3(0.0,0.0,1.0); break;
		case 11: passColour = vec3(0.2,0.0,1.0); break;
		case 14: passColour = vec3(0.3,0.0,1.0); break;
		case 100: passColour = vec3(1.0,1.0,0.3); break;
		case 65280: passColour = vec3(0.6,0.3,0.4); break;
		default: passColour = vec3(0.8,0.8,0.8); break;
	}
	
	if (type > 7000) {
		passColour = vec3(0.7,0.4,0.0);
	}
	
	if (isWarp == 1.0) {
		passColour = vec3(0.8,0.0,1.0);
	}
}













