#include "IDGenerator.h"
#include <random>
#include <sstream>
#include <iomanip>
#include <stdexcept>
#include <cctype>

namespace NeuralStudio {

std::string IDGenerator::generate(Species species, const std::string &type, const std::string &archetype)
{
	validate(type, archetype);

	std::string paddedType = pad(type, 2, '0');
	std::string paddedArch = pad(archetype, 4, '0');

	std::ostringstream oss;
	oss << static_cast<char>(species) << paddedType << paddedArch << "-" << generateUUID();

	return oss.str();
}

Species IDGenerator::parseSpecies(const std::string &id)
{
	if (id.empty()) {
		throw std::invalid_argument("ID is empty");
	}
	return static_cast<Species>(id[0]);
}

std::string IDGenerator::parseType(const std::string &id)
{
	if (id.length() < 3) {
		throw std::invalid_argument("ID too short to parse type");
	}
	return id.substr(1, 2);
}

std::string IDGenerator::parseArchetype(const std::string &id)
{
	if (id.length() < 7) {
		throw std::invalid_argument("ID too short to parse archetype");
	}
	return id.substr(3, 4);
}

std::string IDGenerator::parseUUID(const std::string &id)
{
	size_t dashPos = id.find('-');
	if (dashPos == std::string::npos || dashPos != 7) {
		throw std::invalid_argument("Invalid ID format: dash expected at position 7");
	}
	return id.substr(dashPos + 1);
}

bool IDGenerator::isValid(const std::string &id)
{
	// Format: [1][2][4]-[36] = 44 chars total
	if (id.length() != 44)
		return false;
	if (id[7] != '-')
		return false;

	// Validate species (letters + digits 0-7)
	char species = id[0];
	const std::string validSpecies = "NCPSERMAOGLUWFDTVZJYIBQKHX0123456";
	if (validSpecies.find(species) == std::string::npos) {
		return false;
	}

	// Validate type (2 uppercase alphanumeric)
	for (int i = 1; i <= 2; ++i) {
		if (!std::isalnum(static_cast<unsigned char>(id[i])))
			return false;
	}

	// Validate archetype (4 uppercase alphanumeric)
	for (int i = 3; i <= 6; ++i) {
		if (!std::isalnum(static_cast<unsigned char>(id[i])))
			return false;
	}

	// Validate UUID format (basic check)
	std::string uuid = id.substr(8);
	if (uuid.length() != 36)
		return false;
	if (uuid[8] != '-' || uuid[13] != '-' || uuid[18] != '-' || uuid[23] != '-') {
		return false;
	}

	return true;
}

bool IDGenerator::isSpecies(const std::string &id, Species species)
{
	if (id.empty())
		return false;
	return id[0] == static_cast<char>(species);
}

// Private helpers

std::string IDGenerator::generateUUID()
{
	static std::random_device rd;
	static std::mt19937 gen(rd());
	static std::uniform_int_distribution<> dis(0, 15);
	static std::uniform_int_distribution<> dis2(8, 11);

	std::ostringstream oss;
	oss << std::hex;

	for (int i = 0; i < 8; ++i)
		oss << dis(gen);
	oss << "-";
	for (int i = 0; i < 4; ++i)
		oss << dis(gen);
	oss << "-4"; // Version 4
	for (int i = 0; i < 3; ++i)
		oss << dis(gen);
	oss << "-";
	oss << dis2(gen); // Variant bits
	for (int i = 0; i < 3; ++i)
		oss << dis(gen);
	oss << "-";
	for (int i = 0; i < 12; ++i)
		oss << dis(gen);

	return oss.str();
}

std::string IDGenerator::pad(const std::string &str, size_t length, char padChar)
{
	if (str.length() >= length) {
		return str.substr(0, length);
	}
	return str + std::string(length - str.length(), padChar);
}

void IDGenerator::validate(const std::string &type, const std::string &archetype)
{
	if (type.empty() || type.length() > 2) {
		throw std::invalid_argument("Type must be 1-2 characters");
	}
	if (archetype.empty() || archetype.length() > 4) {
		throw std::invalid_argument("Archetype must be 1-4 characters");
	}

	// Validate uppercase alphanumeric
	for (char c : type) {
		if (!std::isalnum(static_cast<unsigned char>(c))) {
			throw std::invalid_argument("Type must be alphanumeric");
		}
	}
	for (char c : archetype) {
		if (!std::isalnum(static_cast<unsigned char>(c))) {
			throw std::invalid_argument("Archetype must be alphanumeric");
		}
	}
}

} // namespace NeuralStudio
