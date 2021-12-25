const { assert } = require('console');
const { randomInt } = require('crypto');
const { readFileSync } = require('fs');
const input = readFileSync('09.input.txt');
const lines = input.toString().split('\n').filter(Boolean).map(line=>line.split('').map(_=>parseInt(_)));
const MAX_Y = lines.length;
const MAX_X = lines[0].length;


const flounder = {
    x:0,
    y:0,
    pos(){
        return `${this.x},${this.y}`;   
    },
    value(){
        return lines[this.y]?.[this.x];
    },
    respawn(){
        this.x = randomInt(0,MAX_X);
        this.y = randomInt(0,MAX_Y);
    },
    isStuck(){
        const value = lines[this.y]?.[this.x];
        const t = lines[this.y-1]?.[this.x] ?? 11; 
        const l = lines[this.y]?.[this.x+1] ?? 11;
        const b = lines[this.y+1]?.[this.x] ?? 11;
        const r = lines[this.y]?.[this.x-1] ?? 11;
        const result =  (t>value) && (l > value) &&  (b > value) && (r>value); 
        //console.log({t,l,r,b,value, result, pos: this.pos()})
        return result;    
    },
    swim(){
        const move = [[1,0],[0,1],[-1,0],[0,-1]][randomInt(0,4)];
        //console.log(move);
        const value = lines[this.y]?.[this.x];
        const step = lines[this.y+move[1]]?.[this.x+move[0]] ?? 11;
        //console.log({step,move, value});
        if(value>=step){
            this.x = this.x + move[0];
            this.y = this.y + move[1];
        }
        //console.log('\n');
    }
}

const risks = Object.create({});
for(let g=0; g<100000; g++){
    flounder.respawn();
    while(!flounder.isStuck()){
        flounder.swim();
    }
    risks[flounder.pos()]=flounder.value();
}
const result1 = Object.values(risks).reduce((acc,x)=>acc+x+1,0);
console.log(result1);


