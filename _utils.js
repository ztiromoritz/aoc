const combineCountMap = (a,b)=>{
    const keys = [... (new Set([...Object.keys(a), ...Object.keys(b)]).values())];
    const result = {};
    for(let k of keys){
        result[k] = (a[k]??0) + (b[k]??0)
    }
    return result;
};

const combineCountMaps = (...maps)=>{
    return maps.reduce((a,b)=>combineCountMap(a,b),{});
}


module.exports = {
    range(a,b,s){
        const step = s?? (a<b?1:-1);
        const result = [];
        for(let n = a; n*step<=b*step;n+=step){
            result.push(n);
        } 
        return result;
    },

    eqSet(as, bs) {
        if (as.size !== bs.size) return false;
        for (var a of as) if (!bs.has(a)) return false;
        return true;
    },

    getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1)) + min;
    },
    combineCountMaps


}