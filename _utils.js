module.exports = {
    range(a,b,s){
        const step = s?? (a<b?1:-1);
        const result = [];
        for(let n = a; n*step<=b*step;n+=step){
            result.push(n);
        } 
        return result;
    }
}