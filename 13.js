const {range} = require('./_utils');
const { readFileSync } = require('fs');
const id = ([x,y])=>[x,y];
const foldX =  (m) => ([x,y])=> {
    const x_ = x<=m?x:2*m-x;
    return [x_,y]
}
const foldY = (m)=> ([x,y])=>{
    const y_ = y<=m?y:(2*m-y);
    return [x,y_];
}
const compose = (f,g)=> v => g(f(v));

function parseInput(){
  
    const input = readFileSync('13.input.txt');
    const lines = input.toString().split('\n').filter(line=>!line.startsWith("#"));

    const points = [];
    const rules = [];
    let state = 'POINTS';
    for(let line of lines){
        if(line === ""){ 
            state = 'RULES'
        }else if(state === 'POINTS'){
            points.push(line.split(",").map((_)=>parseInt(_)));
        }else if(state === 'RULES'){
            const [d,m] = line.split(" ")[2].split("=");
            rules.push(d==="x"?foldX(parseInt(m)):foldY(parseInt(m)));
        }
    }
    return {points, rules};   
}


const {points, rules} = parseInput();
const result = {};
let X = -1;
let Y = -1;

const transform = rules.reduce(compose, id);
//const transform = rules[0];
points.map(transform).forEach(([x,y])=>{
    X = Math.max(X, x);
    Y = Math.max(Y, y);
    result[`${x}:${y}`]="#";
});

const matrix = [];
for(let y of range(0,Y)){
    let line = [];
    for(let x of range(0,X)){
        line.push(result[`${x}:${y}`]??' ')
    }
    matrix.push(line.join(""));
}

console.log(JSON.stringify(matrix,null,1));
console.log(Object.entries(result).length)
