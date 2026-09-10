#version 330

layout (location=0) in vec4 vertex; // position of current vertex
layout (location=1) in vec3 normal; // normal to current vertex

// variables can be modified in Pinned menu
uniform bool disableMorphing;
uniform float damping;
uniform float minVal;
uniform float maxVal;

uniform mat4 matVP; // camera's view matrix * perspective projection matrix
uniform mat4 matGeo; // GeometryTransform, pipeline item's transform matrix

uniform float time;	// variable that keeps the time
varying vec3 color; // variable that keeps the color of a vertex

//Computes the intersection of the unit cube with the
//half-line starting in the origin and incident with the current vertex.
//Returns 2D coordinates of hit point on the cube face.

vec2 intersect(vec3 p) {
	float maxComp = max(max(abs(p.x), abs(p.y)), abs(p.z));
	vec3 q = p / maxComp;

	if (abs(q.x) >= abs(q.y) && abs(q.x) >= abs(q.z)) {
		return vec2(q.y, q.z);
	} else if (abs(q.y) >= abs(q.x) && abs(q.y) >= abs(q.z)) {
		return vec2(q.x, q.z);
	} else {
		return vec2(q.x, q.y);
	}
} 
		
//Handles the morphing of the vertices.
//For each vertex returns how much it should be offset.
float offset(vec3 p) {	
	vec2 st;
	
	// computes intersection with unit cube
	st = intersect(p);
	
	float restriction = dot(st,st);
	
	//The limit is set to 1 to restrict morphing
	//to only the circle of radius 1 on each cube face,
	//leaving the edges and corners stationary.
	float limit = 1.0;
				
	if(restriction<limit) {	
		// The bias scales inversely to the vertice's distance
		// from the center of the cube face
		float bias = limit - restriction;
		return sin(time/2.0) * (bias);
	} else  {
	   return 0.0;
	}
}
		
void main()
{
	//Compute the MVP matrix.
	mat4 ModelViewProjectionMatrix = matVP * matGeo;
    
	vec3 p = vertex.xyz/vertex.w;
	
	if (!disableMorphing) {
		p = p + clamp(damping*offset(p),minVal,maxVal) * normalize(normal);
	}
		
	//Compute position for each point by multiplying with
	//the matrix in homogenous coordinates.
	gl_Position = ModelViewProjectionMatrix * vec4(p, 1.0);
	color=abs(p);
}
