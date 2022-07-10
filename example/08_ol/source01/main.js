import './style.css'
import GeoJSON from 'ol/format/GeoJSON'
import Map from 'ol/Map'
import VectorLayer from 'ol/layer/Vector'
import VectorSource from 'ol/source/Vector'
import View from 'ol/View'
import sync from 'ol-hashed'
import DragAndDrop from 'ol/interaction/DragAndDrop'

const map = new Map({
    target: "map",
    layers: [new VectorLayer({
        source: new VectorSource({
            format: new GeoJSON(),
            url: "openlayers-workshop-en/data/countries.json"
        })
    })],
    view: new View({
        center: [0, 0],
        zoom: 2
    })
});;
sync(map);