const {
    csv,
    select,
    scaleLinear,
    extent,
    axisLeft,
    axisBottom
} = d3

function tryScatter() {
    const csvUrl = "iris.csv";;
    let parseRaw = function(d) {
        d.sepal_width = +d.sepal_width;
        d.sepal_length = +d.sepal_length;
        d.petal_length = +d.petal_length;
        d.petal_width = +d.petal_width;
        return d;
    };;
    const xValue = function(d) {
        return d.petal_length;
    };;
    const yValue = function(d) {
        return d.sepal_length;
    };;
    const radius = 5;;
    const main = async function() {
        const data = await csv(csvUrl, parseRaw);;
        let margin = {
            top: 20,
            right: 20,
            bottom: 40,
            left: 50
        };;
        const width = window.innerWidth;;
        const height = window.innerHeight;;
        const x = scaleLinear().domain(extent(data, xValue)).range([margin.left, ((width) - (margin.right))]);;
        const y = scaleLinear().domain(extent(data, yValue)).range([((height) - (margin.bottom)), margin.top]);;
        const marks = data.map(function(d) {
            return {
                x: x(xValue(d)),
                y: y(yValue(d))
            };
        });;
        const svg = select("body").append("svg").attr("width", width).attr("height", height);;
        svg.selectAll("circle").data(marks).join("circle").attr("cx", function(d) {
            return d.x;
        }).attr("cy", function(d) {
            return d.y;
        }).attr("r", radius);
        svg.append("g").attr("transform", `translate(${margin.left},0)`).call(axisLeft(y));
        svg.append("g").attr("transform", `translate(0,${height - margin.bottom})`).call(axisBottom(x));;
    };;
    main();;
}
window.onerror = function(msg, src, lineno, colno, error) {
    if (error) {
        alert((("error:") + (msg) + (src) + (lineno) + (colno) + (JSON.stringify(error))));
    };
    return true;
}

window.onload = function() {
    tryScatter();
}