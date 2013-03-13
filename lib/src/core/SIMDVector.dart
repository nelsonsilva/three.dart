part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author kile / http://kile.stravaganza.org/
 * @author philogb / http://blog.thejit.org/
 * @author mikael emtinger / http://gomo.se/
 * @author egraether / http://egraether.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

abstract class SIMDVector<T extends SIMDVector> {
  Float32x4 _v;

  SIMDVector( [num x = 0, num y = 0, num z = 0, num w = 0] ) {
    _setValues(x, y, z, w);
  }

  get x => _v.x;
  get y => _v.y;
  get z => _v.z;
  get w => _v.w;

  set x(num x) { setX(x); }
  set y(num y) { setY(y); }
  set z(num z) { setZ(z); }
  set w(num w) { setW(w); }

  // changed "set" to "setValues" as "set" is reserved.
  T _setValues( num x, num y, num z, num w ) {
    _v = new Float32x4(x.toDouble(), y.toDouble(), z.toDouble(), w.toDouble());
    return this;
  }

  T setX( num x ) {
    _v = _v.withX(x.toDouble());
    return this;
  }

  T setY( num y ) {
    _v = _v.withY(y.toDouble());
    return this;
  }

  T setZ( num z ) {
    _v = _v.withZ(z.toDouble());

    return this;
  }

  T setW( num w ) {
    _v = _v.withW(w.toDouble());

    return this;
  }

  T copy( SIMDVector v ) => _setValues(v.x, v.y, v.z, v.w);

  T add( T v1, T v2 ) {
    _v = v1._v + v2._v;

    return this;
  }

  T addSelf( T v ) {
    _v += v._v;

    return this;
  }

  T addScalar( num s ) {
    var sd = s.toDouble();
    var sv = new Float32x4(sd, sd, sd, sd);
    _v += sv;

    return this;
  }

  T sub( T v1, T v2 ) {
    _v = v1._v - v2._v;

    return this;
  }

  T subSelf( T v ) {
    _v -= v._v;

    return this;
  }

  T multiply( T a, T b ) {
    _v = a._v * b._v;

    return this;
  }

  T multiplySelf( T v ) {
    _v *= v._v;

    return this;
  }

  T multiplyScalar( num s ) {
    var sd = s.toDouble();
    var sv = new Float32x4(sd, sd, sd, sd);
    _v = _v * sv;

    return this;
  }

  T divideSelf( T v ) {
    _v /= v._v;

    return this;
  }

  T divideScalar( num s ) {
    if ( s != 0 ) {
      var sd = s.toDouble();
      var sv = new Float32x4(sd, sd, sd, sd);
      _v = _v / sv;
    } else {
      _v = new Float32x4.zero();
    }

    return this;
  }

  T negate() => multiplyScalar( -1 );

  num dot( T v ) {
    var m = _v * v._v;
    return m.x + m.y + m.z + m.w;
  }

  // TODO - These should probably be getters

  num lengthSq() {
    var m = _v * _v;
    return m.x + m.y + m.z + m.w;
  }

  num length() => Math.sqrt( lengthSq() );

  num lengthManhattan() {
    var m = _v.abs();
    return m.x + m.y + m.z + m.w;
  }


  T normalize() => divideScalar( length() );

  T setLength( l ) => normalize().multiplyScalar( l );

  lerpSelf( T v, num alpha ) {

    //this.xyz += ( v.xyz - this.xyz ) * alpha;

    var m = v._v - _v;
    m = m.scale(alpha);
    _v += m;

    return this;

  }

  T cross( T a, T b ) {
    var a1 = new Float32x4(a._v.y, a._v.z, a._v.x, a._v.w); //a._v.yzxw;
    var b1 = new Float32x4(b._v.z, b._v.x, b._v.y, b._v.w); //b._v.zxyw;

    var a2 = new Float32x4(a._v.z, a._v.x, a._v.y, a._v.w); //a._v.zxyw;
    var b2 = new Float32x4(b._v.y, b._v.z, b._v.x, b._v.w); //b._v.yzxw;

    _v = (a1 * b1) - (a2 * b2);

    //x = a.y * b.z - a.z * b.y;
    //y = a.z * b.x - a.x * b.z;
    //z = a.x * b.y - a.y * b.x;

    return this;
  }

  T crossSelf( T v ) {

    cross(this, v);

    return this;
  }

  num distanceTo( T v ) => Math.sqrt( distanceToSquared( v ) );

  num distanceToSquared( T v ) {
    var s =_v - v._v;
    var m = s * s;
    return m.x + m.y + m.z + m.w;
  }

  bool equals( v ) {
    if (v == null) return false;
    var e = _v.equal(v._v);
    return e.flagX && e.flagY && e.flagZ && e.flagW;
  }

  bool isZero() => ( lengthSq() < 0.0001 /* almostZero */ );

  T clone();

  toString() => "($x, $y, $z)";
}


