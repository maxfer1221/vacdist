"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
exports.__esModule = true;
exports.runPythonScript = exports.writeOptimalLocation = void 0;
var index_js_1 = require("./index.js");
var util = require('util');
var exec = util.promisify(require('child_process').exec);
var fetch = require('node-fetch');
function writeOptimalLocation(zip) {
    return __awaiter(this, void 0, void 0, function () {
        var location, res;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4, findOptimalLocation(zip)];
                case 1:
                    location = _a.sent();
                    return [4, index_js_1.db.collection('optimal_locations').add({
                            zip: zip,
                            lat: location.lat,
                            long: location.long,
                            date_created: new Date(Date.now())
                        })];
                case 2:
                    res = _a.sent();
                    return [2];
            }
        });
    });
}
exports.writeOptimalLocation = writeOptimalLocation;
function findOptimalLocation(zip) {
    return __awaiter(this, void 0, void 0, function () {
        var radius, zips, appearances, pyout;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    radius = 5;
                    return [4, zipCodesFromRadius(zip, radius)];
                case 1:
                    zips = _a.sent();
                    return [4, findZipAppearances(zips)];
                case 2:
                    appearances = _a.sent();
                    return [4, runPythonScript("./python/optimalLocation.py", [JSON.stringify(appearances)])];
                case 3:
                    pyout = _a.sent();
                    if (!pyout.error) {
                        return [2, JSON.parse(pyout.scriptOutput)];
                    }
                    return [2, __assign({ lat: undefined, long: undefined }, pyout)];
            }
        });
    });
}
function findZipAppearances(zips) {
    return __awaiter(this, void 0, void 0, function () {
        var results, short_zips, users;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    results = [];
                    _a.label = 1;
                case 1:
                    if (!(zips.length > 0)) return [3, 3];
                    short_zips = zips.splice(0, 10);
                    return [4, index_js_1.usersRef.where('zip', 'in', short_zips).get()];
                case 2:
                    users = _a.sent();
                    results.concat(users);
                    return [3, 1];
                case 3:
                    results.map(function (el) { return el.zip; });
                    return [2, results];
            }
        });
    });
}
function zipCodeApi_get(zip, radius) {
    var uri = "https://www.zipcodeapi.com/rest/<api_key>/radius.json/<zip>/<radius>/mile";
    uri = uri.replace('<zip>', '' + zip).replace('<radius>', '' + radius).replace('<api_key>', index_js_1.ZIP_CODE_API_KEY);
    return fetch(uri);
}
function zipCodesFromRadius(zip, radius) {
    return __awaiter(this, void 0, void 0, function () {
        var res, json;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4, zipCodeApi_get(zip, radius)];
                case 1:
                    res = _a.sent();
                    return [4, res.json()];
                case 2:
                    json = _a.sent();
                    return [2, json.zip_codes.map(function (el) { return el.zip_code; })];
            }
        });
    });
}
;
function runPythonScript(pathToScript, parameters) {
    return __awaiter(this, void 0, void 0, function () {
        var _a, stdout, stderr;
        return __generator(this, function (_b) {
            switch (_b.label) {
                case 0: return [4, exec("py \"" + pathToScript + "\" " + parameters.join(' '))];
                case 1:
                    _a = _b.sent(), stdout = _a.stdout, stderr = _a.stderr;
                    return [2, {
                            scriptOutput: stdout,
                            scriptError: stderr,
                            error: !!stderr
                        }];
            }
        });
    });
}
exports.runPythonScript = runPythonScript;
