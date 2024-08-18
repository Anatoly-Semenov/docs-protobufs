#!/usr/bin/env python

from setuptools import setup, find_packages

with open("README.md", "r", encoding="UTF-8") as fh:
    long_description = fh.read()

requirements = ["grpcio", "protobuf"]

test_requirements = [ ]

setup(
    author="",
    python_requires='>=3.6',
    classifiers=[
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        "Operating System :: OS Independent",
    ],
    description="Python packages for protobufs",
    version='0.1.0',
    long_description=long_description,
    long_description_content_type="text/markdown",
    include_package_data=True,
    install_requires=requirements,
    keywords='docs_protobufs',
    name='docs_protobufs',
    packages=find_packages(include=['docs', 'docs.*']),
    zip_safe=False,
    license=MIT
)
