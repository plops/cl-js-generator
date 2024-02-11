import * as THREE from 'https://cdn.skypack.dev/three@0.141.0?min';

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
const renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

const sphereGeometry = new THREE.SphereGeometry(2,32,32);

const wireframeMaterial = new THREE.MeshBasicMaterial({
    color: 0xffffff,
    wireframe: true,
    transparent: true,
    opacity: 0.5
});

const sphere = new THREE.Mesh(sphereGeometry, wireframeMaterial);
scene.add(sphere);

const blackSphereGeometry = new THREE.SphereGeometry(1.99,32,32);
const blackMaterial = new THREE.MeshBasicMaterial({
    color: 0x000000,
    opacity: 0.9,
});
const blackSphere = new THREE.Mesh(blackSphereGeometry, blackMaterial);
scene.add(blackSphere);

camera.position.z = 5;

function animate() {
    requestAnimationFrame(animate);
    sphere.rotation.x += 0.005;
    sphere.rotation.y += 0.01;
    renderer.render(scene, camera);
}

animate();