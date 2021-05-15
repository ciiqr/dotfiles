const fs = require('fs');
const path = require('path');

const cwd = process.cwd();
const name = cwd.split('/').pop();

const editorconfig =
`root = true

[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
insert_final_newline = true
trim_trailing_whitespace = true

[*.{yaml,yml}]
indent_size = 2
`;

const gitignore =
`node_modules
`;

const npmignore =
`.npmignore
.editorconfig
.gitattributes
`;

const files = {
    '.editorconfig': editorconfig,
    '.gitignore': gitignore,
    '.npmignore': npmignore,
};

for (const [fileName, fileContent] of Object.entries(files)) {
    const filePath = path.join(cwd, fileName);
    fs.writeFileSync(filePath, fileContent);
}

module.exports = {
    name: name,
    version: '0.1.0',
    description: '',
    author: 'ciiqr',
    license: 'MIT',
    private: true,
    main: 'index.js',
    scripts: {
        'start': 'node index.js',
        'test': 'echo "Error: no test specified" && exit 1'
    },
};
