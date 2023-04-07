// eslint-disable-next-line no-undef
module.exports = {
    preset: 'ts-jest',
    collectCoverage: true,
    coverageDirectory: 'reports/coverage',
    coverageProvider: 'v8',
    collectCoverageFrom: [
        "src/**/*.ts",
        "!**/node_modules/**"
    ],
    testEnvironment: 'node',
    transform: {
        '^.+\\.ts?$': 'ts-jest',
    },
    transformIgnorePatterns: ['<rootDir>/node_modules/'],
};