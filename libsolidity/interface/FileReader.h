/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0
#pragma once

#include <boost/filesystem.hpp>

#include <map>
#include <set>

#include <libsolidity/interface/ImportRemapper.h>
#include <libsolidity/interface/ReadFile.h>

namespace solidity::frontend
{

/// FileReader - used for progressively loading source source code.
///
/// It is used in solc to load files from CLI parameters, stdin, or from JSON and
/// also used in the solc language server where solc is a long running process.
class FileReader
{
public:
	using StringMap = std::map<SourceUnitID, SourceCode>;
	using PathMap = std::map<SourceUnitID, boost::filesystem::path>;
	using FileSystemPathSet = std::set<boost::filesystem::path>;

	/// Constructs a FileReader with a base path and a set of allowed directories that
	/// will be used when requesting files from this file reader instance.
	explicit FileReader(
		boost::filesystem::path _basePath = {},
		FileSystemPathSet _allowedDirectories = {}
	):
		m_basePath(std::move(_basePath)),
		m_allowedDirectories(std::move(_allowedDirectories)),
		m_sourceCodes(),
		m_sourceCodeOrigin()
	{}

	void setBasePath(boost::filesystem::path _path) { m_basePath = std::move(_path); }
	std::string basePath() const noexcept { return m_basePath.generic_string(); }

	void allowDirectory(boost::filesystem::path _path) { m_allowedDirectories.insert(std::move(_path)); }
	FileSystemPathSet const& allowedDirectories() const noexcept { return m_allowedDirectories; }

	StringMap const& sourceCodes() const noexcept { return m_sourceCodes; }

	/// Retrieves the list of mappings between source unit ID and their representative file system path.
	PathMap const& origins() const noexcept { return m_sourceCodeOrigin; }

	/// Retrieves the source code for a given source unit ID.
	SourceCode const& sourceCode(SourceUnitID const& _sourceUnitID) const { return m_sourceCodes.at(_sourceUnitID); }

	/// Resets all sources to the given map of source unit ID to source codes.
	void setSources(StringMap _sources);

	/// Adds the source code for a given file system path.
	///
	/// The source unit ID will be equivalent to the source unit ID.
	void setSource(boost::filesystem::path _fspath, SourceCode _source);

	/// Adds the source code for a given source unit ID.
	void setSource(SourceUnitID sourceUnitID, SourceCode _source);

	/// Adds given source, imported as @p _path with filesystem path @p _fspath.
	void setSource(SourceUnitID _sourceUnitID, std::optional<boost::filesystem::path> _fspath, SourceCode _source);

	/// Reads a given file at @p _path of kind @p _kind from the local filesystem and returns the result.
	/// @p _kind must always be passed as "source".
	frontend::ReadCallback::Result readFile(std::string const& _kind, std::string const& _path);

	frontend::ReadCallback::Callback reader()
	{
		return [this](std::string const& _kind, std::string const& _path) { return readFile(_kind, _path); };
	}

private:
	/// Base path, used for resolving relative paths in imports.
	boost::filesystem::path m_basePath;

	/// list of allowed directories to read files from
	FileSystemPathSet m_allowedDirectories;

	/// map of input files to source code strings
	StringMap m_sourceCodes;

	/// map of input file names to full path names suitable for file://-URIs
	PathMap m_sourceCodeOrigin;
};

}
