const {readFileSync} = require('fs');
const input = readFileSync('06.input.txt');
const fishes = input.toString().split(',').filter(Boolean).map(_=>parseInt(_));
console.log("initial         [ "+String(fishes.length).padStart(5," ") + " ]")//, fishes.map(_=>String(_).padStart(2," ")).join());
const fishesByAge = [0,0,0,0,0,0,0,0,0];
fishes.forEach(age=>{
    fishesByAge[age]++;
})
console.log(fishesByAge);

for(let d = 0; d<256; d++){
    let i = 9;

    const spawn = fishesByAge[0];
    for(i=1;i<9;i++){
       fishesByAge[i-1] = fishesByAge[i];
    }
    fishesByAge[6]+=spawn;
    fishesByAge[8]=spawn;
    const sum = fishesByAge.reduce((a,b)=>a+b,0);
    console.log("after "+String(d).padStart(2," ")+" day(s) [ "+String(sum).padStart(5," ") + " ]")//, fishes.map(_=>String(_).padStart(2," ")).join());
}

/*
Initial state: 3,4,3,1,2
After  1 day:  2,3,2,0,1
After  2 days: 1,2,1,6,0,8
After  3 days: 0,1,0,5,6,7,8
After  4 days: 6,0,6,4,5,6,7,8,8
After  5 days: 5,6,5,3,4,5,6,7,7,8
After  6 days: 4,5,4,2,3,4,5,6,6,7
After  7 days: 3,4,3,1,2,3,4,5,5,6
After  8 days: 2,3,2,0,1,2,3,4,4,5
After  9 days: 1,2,1,6,0,1,2,3,3,4,8
After 10 days: 0,1,0,5,6,0,1,2,2,3,7,8
*/