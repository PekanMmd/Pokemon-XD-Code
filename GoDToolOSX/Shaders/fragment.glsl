#version 330 core

uniform vec3 lightColor;
uniform vec3 lightPosition;
uniform float lightAmbient;
uniform float k_specular;
uniform float shininess;

in vec3 barycentric;
in vec3 passColour;
in vec3 passPosition;
in vec3 passNormal;

in vec2 passProjection;

out vec4 outColor;

void main() {
	
	vec3  normal = normalize(passNormal);
	vec3  lightRay = normalize(lightPosition - passPosition);
	float intensity = dot(normal, lightRay) / (length(normal) * length(lightRay));
	intensity = clamp(intensity, 0, 1);
	
	vec3 viewer = normalize(vec3(0.0, 0.0, -0.2) - passPosition);
	vec3 reflection = reflect(lightRay, normal);
	
	float specular = pow(max(dot(viewer, reflection), 0.0), shininess);
	vec3 light = vec3(lightAmbient, lightAmbient, lightAmbient) + lightColor * intensity + k_specular * specular * lightColor;
	
	vec3 surface = passColour;
	vec3 rgb = surface * light;
	
	outColor = vec4(rgb, 1.0);
	
	// wireframe
	if(any(lessThan(barycentric, vec3(0.01)))) {
		outColor = vec4(0.0, 0.0, 0.0, 1.0);
	} else{
		outColor = vec4(rgb, 1.0);
	}
}



