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

// TODO: Given a 3d vector p, which represents the vector from the origin
// calculate the intersection with the unit cube

vec2 intersect(vec3 p) {
	return vec2(0,0);
} 
		
float offset(vec3 p) {	
	vec2 st;
	
	// computes intersection with unit cube
	st = intersect(p);
	
	float restriction = dot(st,st);
	
	// TODO: Come up with a way to restrict face transformations
	// Hint: Think a about how to limit the
	// vertices, on which morphing is applied | 1 point		
	float limit;
				
	if(restriction<limit) {	
		// TODO: Come up with a correct bias,
		// such that the required morphing effect
		// is present | 3 points	
		float bias = 1;
		return sin(time/2.0) * (bias);
	} else  {
	   return 0.0;
	}
}

		
void main()
{
	// TODO: compute ModelViewProjectionMatrix in terms of 
	// 		 given matrix variables  | 1 point
	mat4 ModelViewProjectionMatrix;
    		
    
	vec3 p = vertex.xyz/vertex.w;
	
	if (!disableMorphing) {
		p = p + clamp(damping*offset(p),minVal,maxVal) * normalize(normal);
	}
	
	// pass vertex attributes to the fragment shader.
	
	// TODO: compute gl_Position in terms of 
	// ModelViewProjectionMatrix and p | 1 point		
	 
	gl_Position;	
	color=abs(p);
}
