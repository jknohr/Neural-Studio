#pragma once

#include <string>

namespace NeuralStudio {

enum class Species {
	// Core entities
	Node = 'N',
	Controller = 'C',
	Pipeline = 'P',
	Settings = 'S',
	Edge = 'E',
	Rule = 'R',

	// Media & Assets
	Media = 'M',
	MediaAsset = 'A',
	Model = 'O', // 3D models, ML models
	SceneGraphAsset = 'G',

	// UI & Interaction
	UI = 'U',
	UIElement = 'L',
	Widget = 'W',
	Frame = 'F',
	Dock = 'D',
	Monitor = 'V',

	// Execution & Events
	Task = 'T',
	Event = 'Z',
	Session = 'J',

	// Connectivity
	API = 'I',
	APIBinding = 'Y',
	InteractionBinding = 'B',
	TransportStream = 'Q',
	IPStream = 'K',
	Bluetooth = 'H',

	// Systems
	Manager = 'X',
	Profile = '0',
	Hardware = '1',

	// Advanced
	WASM = '2',
	Conversation = '3',
	File = '4',
	CSP = '5', // Content Security Policy / Cloud Service Provider
	CDN = '6', // Content Delivery Network

	// Reserved for future
	Extension = '7'
};

/**
 * @brief Universal ID Generator
 * 
 * Generates structured IDs: [Species:1][Type:2][Archetype:4]-[UUID:36]
 * Example: "NAUCLIP-550e8400-e29b-41d4-a716-446655440000"
 * 
 * Benefits:
 * - Self-documenting (can infer type from ID)
 * - Fast filtering (no database queries needed)
 * - Consistent across entire system
 */
class IDGenerator {
public:
	/**
     * Generate structured ID
     * @param species High-level category (N, C, P, S, etc.)
     * @param type 2-character type code (AU, VD, GR, etc.)
     * @param archetype 4-character archetype code (CLIP, STRM, etc.)
     * @return Structured ID string
     */
	static std::string generate(Species species, const std::string &type, const std::string &archetype);

	// Convenience methods
	static std::string generateNode(const std::string &type, const std::string &archetype)
	{
		return generate(Species::Node, type, archetype);
	}

	static std::string generatePipeline(const std::string &type, const std::string &archetype)
	{
		return generate(Species::Pipeline, type, archetype);
	}

	static std::string generateSettings(const std::string &type, const std::string &archetype)
	{
		return generate(Species::Settings, type, archetype);
	}

	static std::string generateEdge(const std::string &type, const std::string &archetype)
	{
		return generate(Species::Edge, type, archetype);
	}

	static std::string generateController(const std::string &type)
	{
		return generate(Species::Controller, type, "0000");
	}

	// Parsing
	static Species parseSpecies(const std::string &id);
	static std::string parseType(const std::string &id);
	static std::string parseArchetype(const std::string &id);
	static std::string parseUUID(const std::string &id);

	// Validation
	static bool isValid(const std::string &id);
	static bool isSpecies(const std::string &id, Species species);
	static bool isNodeID(const std::string &id) { return isSpecies(id, Species::Node); }
	static bool isPipelineID(const std::string &id) { return isSpecies(id, Species::Pipeline); }
	static bool isEdgeID(const std::string &id) { return isSpecies(id, Species::Edge); }

private:
	static std::string generateUUID();
	static std::string pad(const std::string &str, size_t length, char padChar);
	static void validate(const std::string &type, const std::string &archetype);
};

} // namespace NeuralStudio
