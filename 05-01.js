const {readFileSync} = require('fs');
const {range} = require('./_utils');
const input = readFileSync('05.input.txt');
const textLines = input.toString().split('\n').filter(Boolean);
const lines = textLines.map(text=>text.split(" ")).map(([p1,_,p2])=>{
    const [x1,y1]=p1.split(',').map(_=>parseInt(_));
    const [x2,y2]=p2.split(',').map(_=>parseInt(_));
    return {
        x1,y1,x2,y2
    }
});
const orthLines = lines.filter(({x1,y1,x2,y2})=>x1===x2||y1===y2);
let grid=Object.create(null);
orthLines.forEach(({x1,y1,x2,y2})=>{
    if(x1===x2){
        const x=x1;
        for(let y of range(y1,y2)){
            grid[`${x}-${y}`] = (grid[`${x}-${y}`] ?? 0)+1;
        }
    }else{
        const y=y1;
        for(let x of range(x1,x2)){
            grid[`${x}-${y}`] = (grid[`${x}-${y}`] ?? 0)+1;
        }
    }
});
const overlaps = Object.entries(grid).filter(([key,value])=>value>=2).length;
console.log("Part1: ",overlaps);
grid = Object.create({});
lines.forEach(({x1,y1,x2,y2})=>{
    if(x1===x2){
        const x=x1;
        for(let y of range(y1,y2)){
            grid[`${x}-${y}`] = (grid[`${x}-${y}`] ?? 0)+1;
        }
    }else if(y1===y2){
        const y=y1;
        for(let x of range(x1,x2)){
            grid[`${x}-${y}`] = (grid[`${x}-${y}`] ?? 0)+1;
        }
    }else{ // 45°
        const x_step = (x1<x2?1:-1);
        const y_step = (y1<y2?1:-1);
        let len = Math.abs(x1-x2) + 1;
        let x = x1;
        let y = y1;
        while(len--){
            grid[`${x}-${y}`] = (grid[`${x}-${y}`] ?? 0)+1;
            x+=x_step;
            y+=y_step;    
        } 
    }
})

const overlaps2 = Object.entries(grid).filter(([key,value])=>value>=2).length;
console.log("Part2: ",overlaps2);