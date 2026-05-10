const fs = require('fs');
const path = require('path');

const srcDir = '/home/samue/.gemini/antigravity/brain/f83cc780-d3c2-4b36-ab53-cfcf672e5de0';
const destDir = path.join(__dirname, 'assets');

if (!fs.existsSync(destDir)) {
  fs.mkdirSync(destDir, { recursive: true });
}

const filesToCopy = [
  { prefix: 'bg_shire_', dest: 'bg_shire.png' },
  { prefix: 'bg_forest_', dest: 'bg_forest.png' },
  { prefix: 'bg_weathertop_', dest: 'bg_weathertop.png' },
  { prefix: 'bg_moria_', dest: 'bg_moria.png' },
  { prefix: 'bg_lothlorien_', dest: 'bg_lothlorien.png' },
  { prefix: 'bg_pelennor_', dest: 'bg_pelennor.png' },
  { prefix: 'bg_mountdoom_', dest: 'bg_mountdoom.png' },
  { prefix: 'fantasy_gate_', dest: 'fantasy_gate.png' },
  { prefix: 'rune_stone_', dest: 'rune_stone.png' },
  { prefix: 'lore_book_', dest: 'lore_book.png' }
];

const allFiles = fs.readdirSync(srcDir);

filesToCopy.forEach(f => {
  const matchingFile = allFiles.find(file => file.startsWith(f.prefix) && file.endsWith('.png'));
  if (matchingFile) {
    fs.copyFileSync(path.join(srcDir, matchingFile), path.join(destDir, f.dest));
    console.log(`Copied ${matchingFile} to assets/${f.dest}`);
  } else {
    console.error(`Could not find file matching prefix ${f.prefix}`);
  }
});
console.log('All local AI assets copied successfully!');
