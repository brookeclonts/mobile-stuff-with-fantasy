import 'package:swf_app/src/profile/models/leaderboard.dart';

/// 25 mock leaderboard entries with fantasy-themed names and varying scores.
///
/// Entry at position 12 is marked as the current user.
final List<LeaderboardEntry> mockLeaderboardEntries = [
  const LeaderboardEntry(
    userId: 'u01',
    userName: 'Thalindra Ashveil',
    rankTitle: 'Archmage',
    score: 247,
    position: 1,
  ),
  const LeaderboardEntry(
    userId: 'u02',
    userName: 'Kael Stormborn',
    rankTitle: 'Archmage',
    score: 231,
    position: 2,
  ),
  const LeaderboardEntry(
    userId: 'u03',
    userName: 'Seraphine Duskhollow',
    rankTitle: 'Archmage',
    score: 218,
    position: 3,
  ),
  const LeaderboardEntry(
    userId: 'u04',
    userName: 'Mordecai Thornwick',
    rankTitle: 'Sage',
    score: 195,
    position: 4,
  ),
  const LeaderboardEntry(
    userId: 'u05',
    userName: 'Isolde Ravenmere',
    rankTitle: 'Sage',
    score: 188,
    position: 5,
  ),
  const LeaderboardEntry(
    userId: 'u06',
    userName: 'Brynn Ironquill',
    rankTitle: 'Sage',
    score: 172,
    position: 6,
  ),
  const LeaderboardEntry(
    userId: 'u07',
    userName: 'Elara Moonweaver',
    rankTitle: 'Sage',
    score: 164,
    position: 7,
  ),
  const LeaderboardEntry(
    userId: 'u08',
    userName: 'Cassian Frostwynd',
    rankTitle: 'Scholar',
    score: 153,
    position: 8,
  ),
  const LeaderboardEntry(
    userId: 'u09',
    userName: 'Vesper Nighthollow',
    rankTitle: 'Scholar',
    score: 141,
    position: 9,
  ),
  const LeaderboardEntry(
    userId: 'u10',
    userName: 'Gareth Emberheart',
    rankTitle: 'Scholar',
    score: 137,
    position: 10,
  ),
  const LeaderboardEntry(
    userId: 'u11',
    userName: 'Lyris Silvanthorn',
    rankTitle: 'Scholar',
    score: 128,
    position: 11,
  ),
  const LeaderboardEntry(
    userId: 'u12',
    userName: 'You',
    rankTitle: 'Chronicler',
    score: 119,
    position: 12,
    isCurrentUser: true,
  ),
  const LeaderboardEntry(
    userId: 'u13',
    userName: 'Orion Dawnkeeper',
    rankTitle: 'Chronicler',
    score: 112,
    position: 13,
  ),
  const LeaderboardEntry(
    userId: 'u14',
    userName: 'Fiora Starwhisper',
    rankTitle: 'Chronicler',
    score: 104,
    position: 14,
  ),
  const LeaderboardEntry(
    userId: 'u15',
    userName: 'Theron Grimshade',
    rankTitle: 'Chronicler',
    score: 97,
    position: 15,
  ),
  const LeaderboardEntry(
    userId: 'u16',
    userName: 'Miriel Oakenshield',
    rankTitle: 'Seeker',
    score: 89,
    position: 16,
  ),
  const LeaderboardEntry(
    userId: 'u17',
    userName: 'Rowan Cinderfall',
    rankTitle: 'Seeker',
    score: 82,
    position: 17,
  ),
  const LeaderboardEntry(
    userId: 'u18',
    userName: 'Astrid Wyndblade',
    rankTitle: 'Seeker',
    score: 76,
    position: 18,
  ),
  const LeaderboardEntry(
    userId: 'u19',
    userName: 'Dorian Spellweaver',
    rankTitle: 'Seeker',
    score: 68,
    position: 19,
  ),
  const LeaderboardEntry(
    userId: 'u20',
    userName: 'Nyla Frostpetal',
    rankTitle: 'Initiate',
    score: 61,
    position: 20,
  ),
  const LeaderboardEntry(
    userId: 'u21',
    userName: 'Cedric Ashborne',
    rankTitle: 'Initiate',
    score: 54,
    position: 21,
  ),
  const LeaderboardEntry(
    userId: 'u22',
    userName: 'Lirael Dewsong',
    rankTitle: 'Initiate',
    score: 47,
    position: 22,
  ),
  const LeaderboardEntry(
    userId: 'u23',
    userName: 'Fenwick Bramblewood',
    rankTitle: 'Initiate',
    score: 39,
    position: 23,
  ),
  const LeaderboardEntry(
    userId: 'u24',
    userName: 'Sylvara Mistcloak',
    rankTitle: 'Novice',
    score: 28,
    position: 24,
  ),
  const LeaderboardEntry(
    userId: 'u25',
    userName: 'Aldric Hollowgale',
    rankTitle: 'Novice',
    score: 15,
    position: 25,
  ),
];

/// Returns a mock [LeaderboardPage] for the given [metric].
///
/// Uses the hardcoded 25-entry list above with the current user at position 12.
LeaderboardPage mockLeaderboardPage({
  LeaderboardMetric metric = LeaderboardMetric.questsSealed,
}) {
  return LeaderboardPage(
    entries: mockLeaderboardEntries,
    metric: metric,
    userPosition: 12,
    total: 1247,
  );
}
