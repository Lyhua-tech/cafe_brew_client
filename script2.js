const fs = require('fs');
const lines = fs.readFileSync('C:/Users/L.Hua/.gemini/antigravity/brain/71f3c055-1ad4-4e09-b4d7-aff634e43936/.system_generated/steps/147/output.txt', 'utf8').split('\n');

let block = [];
let capture = false;
let currentDepth = 0;

for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const indentMatch = line.match(/^( *)/);
    const indent = indentMatch ? indentMatch[1].length : 0;

    if (line.includes("'470:35379':")) {
        capture = true;
        currentDepth = indent;
    } else if (capture && indent <= currentDepth && line.trim() !== '') {
        if (!line.startsWith(' ') && !line.startsWith('-')) {
            // Stop capturing if we hit another top-level key or same level key
            // assuming 470:35379 is somewhere deep
        }
    }

    if (capture) {
        if (line.includes('id:') || line.includes('name:') || line.includes('type:')) {
            console.log(line);
        }
    }
}
