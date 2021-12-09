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
    }
}