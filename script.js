const fs = require('fs');
const lines = fs.readFileSync('C:/Users/L.Hua/.gemini/antigravity/brain/71f3c055-1ad4-4e09-b4d7-aff634e43936/.system_generated/steps/96/output.txt', 'utf8').split('\n');
let currentId = null;
for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (line.match(/^    \'(.*)\':$/) || line.match(/^  \'(.*)\':$/)) {
        currentId = line.replace(/[:\' ]/g, '');
    }
    if (line.includes('id: ')) {
        currentId = line.split('id: ')[1].replace(/\'/g, '').trim();
    }
    if (line.includes('name: Splash') || line.includes('Login_') || line.includes('Sign up -')) {
        console.log(`Found ${line.trim()} at line ${i + 1}, ID: ${currentId}`);
    }
}
