//
//  GoDMetalShaders.metal
//  GoD Tool
//
//  Created by The Steez on 03/09/2018.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
	packed_float3 position;
	float type;
	float index;
	packed_float3  normal;
	float isInteractable;
	float interactionIndex;
};

struct VertexOut {
	float4 position [[position]];
	float4 colour;
	float4 normal;
	float3 barycentric;
};

struct Uniforms {
	float4x4 projectionMatrix;
	float4x4 viewMatrix;
	float interactionIndexToHighlight;
};


vertex VertexOut shader_vertex(const device VertexIn* vertex_array [[ buffer(0) ]], const device Uniforms*  uniforms [[ buffer(1) ]], unsigned int vid [[ vertex_id ]])
{
	
	VertexIn in = vertex_array[vid];
	float4x4 projectionMatrix = uniforms->projectionMatrix;
	float4x4 viewMatrix = uniforms->viewMatrix;
	
	VertexOut out;
	out.position = projectionMatrix * viewMatrix * float4(in.position, 1.0);
	out.normal = float4(in.normal, 1.0);
	
	switch (int(in.index) % 3) {
		case 0: out.barycentric = float3(1.0,0.0,0.0); break;
		case 1: out.barycentric = float3(0.0,1.0,0.0); break;
		case 2: out.barycentric = float3(0.0,0.0,1.0); break;
		default: break;
	}
	
	switch (int(in.type)) {
//		case 0: out.colour = float4(0.2,0.2,0.2, 1.0); break;
//		case 1: out.colour = float4(0.3,0.3,0.4, 1.0); break;
//		case 2: out.colour = float4(0.2,0.3,0.5, 1.0); break;
//		case 3: out.colour = float4(0.2,0.2,0.6, 1.0); break;
//		case 4: out.colour = float4(0.0,0.3,0.7, 1.0); break;
//		case 5: out.colour = float4(0.0,0.2,0.8, 1.0); break;
//		case 6: out.colour = float4(0.0,0.1,0.9, 1.0); break;
//		case 7: out.colour = float4(0.0,0.0,1.0, 1.0); break;
//		case 11: out.colour = float4(0.2,0.0,1.0, 1.0); break;
//		case 14: out.colour = float4(0.3,0.0,1.0, 1.0); break;
//		case 100: out.colour = float4(1.0,1.0,0.3, 1.0); break;
//		case 65280: out.colour = float4(0.6,0.3,0.4, 1.0); break;
		default: out.colour = float4(0.5,0.2,0.2, 1.0); break;
	}
	
	if (in.type > 7000) {
		// walkable floor
		out.colour = float4(0.4, 0.6, 1.0, 1.0);
	}
	
	if (in.isInteractable == 1.0) {
		out.colour = float4(0.9, 0.8, 0.5, 1.0);
		
		if (in.interactionIndex == uniforms->interactionIndexToHighlight) {
			out.colour = float4(0.6, 1.0, 0.4, 1.0);
		}
	}
	
	return out;
}


fragment float4 shader_fragment(VertexOut interpolated [[stage_in]]) {
	
	float4 edgeColour = float4(0.0, 0.0, 0.0, 1.0);
	int isEdge = 0; // used to determine if this region is close to the outline of a triangle
	float bcEdgeWidth = 0.04; // determines how close to the edge the point must be
	if (interpolated.barycentric[0] < bcEdgeWidth || interpolated.barycentric[1] < bcEdgeWidth || interpolated.barycentric[2] < bcEdgeWidth) {
		isEdge = 1;
	}
	
	if (isEdge == 1) {
		return edgeColour;
	}
	
	return float4(interpolated.colour[0], interpolated.colour[1], interpolated.colour[2], interpolated.colour[3]);
}





