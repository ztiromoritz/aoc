const { readFileSync } = require('fs');
const {combineCountMaps: add, range} = require('./_utils');
const input = readFileSync('14.input.txt');
const lines = input.toString().split("\n");
const word = lines[0];
const rules = {};
for(let line of lines.slice(2)){
   const from = line.slice(0,2);
   const to =  line[6];
   rules[from]=to;
}

const cache = {}
const cacheKey = (tupel, depth)=>`${tupel}:${depth}`;
function costChildrenCached(tupel, depth){
    const key = cacheKey(tupel,depth);
    if(!cache[key]){
        cache[key] = costChildren(tupel, depth)
    }
    return cache[key];
}

function costChildren(tupel,depth){
    if(depth === 0){
        return {};
    }else{
        const [a,b] = tupel;
        const c = rules[tupel]
        return add(
            {[c]:1},
            costChildrenCached(`${a}${c}`, depth - 1),
            costChildrenCached(`${c}${b}`, depth -1)
        )
    }
}

function costWordItself(word){
    const chars = [...word];
    return add(...chars.map(c=>({[c]:1})))
}

function wordToTupels(word){
    const chars = [...word];
    return range(0,chars.length-2).map((index)=>`${chars[index]}${chars[index+1]}`)
}

function cost(word,depth){
    const tupels = wordToTupels(word);
    return add(
        costWordItself(word),
        ...wordToTupels(word).map(tupel=>costChildren(tupel,depth))
    )
}

const result = cost(word,40);
console.log(Math.max(...Object.values(result)) - Math.min(...Object.values(result)));