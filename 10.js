
// Part 1
const data = document.querySelector('pre').innerText.split('\n').filter(Boolean);


const open = "([{<";
const close = ")]}>";
const points = [3,57,1197,25137];

let errors = [];
for(const line of data){
    const stack=[];
    const chars = [...line];

    for(const c of chars){
        if(open.includes(c)){
            stack.push(c);
        }else{
            const s = stack.pop();
            //console.log(s,c, open.indexOf(c) );
            if(open.indexOf(s) !== close.indexOf(c)){
                errors.push(c)
            }
        }
    }
}

console.log(errors);
console.log(errors.map(error => {
    const index = close.indexOf(error)
    return points[index]
}).reduce((a,b)=>a+b,0));
