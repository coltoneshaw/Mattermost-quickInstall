//webpack.config.js
const path = require('path');
const webpack = require('webpack');

module.exports = {
    mode: "production",
    devtool: "inline-source-map",
    target: 'node',
    entry: { main: "./src/matterhelp.ts", },
    output: {
        path: __dirname,
        filename: "matterhelp" // <--- Will be compiled to this single file
    },
    resolve: {
        alias: {
            ['@']: path.resolve(__dirname, 'src'),
            ['#']: path.resolve(__dirname, '.')
        },
        extensions: [".ts", ".tsx", ".js"],
    },
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                loader: "ts-loader"
            }
        ]
    },
    plugins: [
        new webpack.BannerPlugin({ banner: '#!/usr/bin/env node', raw: true })
    ],
    optimization: {
        minimize: true
      }
};