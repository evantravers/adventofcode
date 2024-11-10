import { promises as fs } from 'fs';

const input = await fs.readFile('../input/1', 'utf8');
console.log(input)
